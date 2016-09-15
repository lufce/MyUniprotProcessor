###uniprot-all.txtの行数は　17757632

package MyLE;

use Time::HiRes;
require "MyProgressBar.pm";

my $species = "human";
our $dataDir = "../data/$species/rev/";
our $listDir = "../cont_list/$species/rev/";
###


&FTKeyExtractor;


###

sub AddEndMarker{
	my $DBFilename =$MyLE::dataDir."ID-sq_rev_uniprot-all.txt";
	my $ResultFileName = $MyLE::dataDir."ID-sq_rev_uniprot-all2.txt";
	my $routinName = "AddEndMarker";
	
	my $objPB = new MyProgressBar;
	
	my $thisIsFirstLine = 1;
	
	print "$routineName starts\n";
	
	open DB, $DBFilename or die "No file";
	
	$objPB->setAll($DBFilename);
	
	open RF, ">$ResultFileName";
	
	while(<DB>){
		$objPB->nowAndPrint($.);
		
		if(m/^ID/){
			if($thisIsFirstLine){print RF; $thisIsFirstLine = 0;}
			else{print RF "//\n$_";}
		}else{
			print RF;
		}		
	}
	
	print RF "//";
	
	print "$routineName ends\n";
	close DB;	close RF;
}

sub GNDEExtractor{
	my $startTime = Time::HiRes::time();
	my $DBFilename = $MyLE::dataDir."rev_uniprot-all.txt";	
	my $ResultFileName = $MyLE::dataDir."ID-GNDE_rev_uniprot-all.txt";
	my $routineName = "GNDEExtractor";
	
	print "$routineName starts.\n";
	
	my $objPB = new MyProgressBar;
	
	open DB,$DBFilename or die "No file";
	$objPB->setAll($DBFilename);
	
	open RF, ">$ResultFileName" or die "Can not create the result file.";
	
	while(<DB>){
		$objPB->nowAndPrint($.);
		
		if(m/^ID/){
			print RF;
		}elsif(m/^GN|^DE/){
			print RF;
		}elsif(m/^\/\//){
			print RF;
		}		
	}
	print "$routineName ends.\t";
	close DB;	close RF;
	
	printf("%0.3f\n",Time::HiRes::time - $startTime); 
}

sub FTExtractor{
	my $startTime = Time::HiRes::time();
	my $DBFilename = $MyLE::dataDir."rev_uniprot-all.txt";
	my $ResultFileName = $MyLE::dataDir."ID-FT_rev_uniprot-all.txt";
	my $routineName = "FTExtractor";
	
	print "$routineName starts.\n";
	
	my $objPB = new MyProgressBar;
	
	open DB,$DBFilename or die "No file";
	
	$objPB->setAll($DBFilename);
	
	open RF, ">$ResultFileName";
	
	while(<DB>){
		$objPB->nowAndPrint($.);
		
		if(m/^ID/){
			print RF;
		}elsif(m/^FT/){
			print RF;
		}elsif(m/^\/\//){
			print RF;
		}		
	}
	print "$routineName ends.\n";
	close DB;	close RF;
	
	printf("%0.3f\n",Time::HiRes::time - $startTime); 
}

sub sqExtractor{
#This subroutine extracts only amino acid sequences below the SQ line.
	my $startTime = Time::HiRes::time();
	my $DBFilename = $MyLE::dataDir."rev_uniprot-all.txt";
	my $ResultFileName = $MyLE::dataDir."ID-sq_rev_uniprot-all.txt";
	my $routineName = "sqExtractor";
	
	print "$routineName starts.\n";
	
	my $objPB = new MyProgressBar;
	
	open DB,$DBFilename or die "No file";
	
	$objPB->setAll($DBFilename);
	
	$sequence="sq   ";
	
	open RF, ">$ResultFileName";
	
	while(<DB>){
		$objPB->nowAndPrint($.);
		
		if(m/^ID/){
			print RF;
		}elsif(m/^SQ/){
			while(<DB>){
				$objPB->nowAndPrint($.);
				
				if(m|^//|){
					print RF "$sequence\n";
					$sequence="sq   ";
					last;
				}else{
					$_ =~ tr/ //d;
					chomp($_);
					$sequence = $sequence.$_
				}
			}
		}elsif(m/^\/\//){
			print RF;
		}
	}
	print "$routineName ends\n";
	close DB;	close RF;
	
	printf("%0.3f\n",Time::HiRes::time - $startTime); 
}

sub CCExtractor{
	my $startTime = Time::HiRes::time();
	my $DBFilename = $MyLE::dataDir."rev_uniprot-all.txt";
	my $ResultFileName = $MyLE::dataDir."ID-CC_rev_uniprot-all.txt";
	my $routineName = "CCExtractor";
	
	print "$routineName starts.\n";
	
	my $objPB = new MyProgressBar;
	$objPB->setAll($DBFilename);
	
	open DB,$DBFilename or die "No file";
	
	open RF, ">$ResultFileName";
	
	while(<DB>){
		$objPB->nowAndPrint($.);
		
		if(m/^ID/){
			print RF;
		}elsif(m/^CC/){
			print RF;
		}elsif(m/^\/\//){
			print RF;
		}
	}
	print "$routineName ends\n";
	close DB;	close RF;
	
	printf("%0.3f\n",Time::HiRes::time - $startTime); 
}

sub SLExtractor{
### This subroutine extracts SUBCELLULAR LOCATION in CC Lines.

	my $startTime = Time::HiRes::time();
	my $DBFilename = $MyLE::dataDir."rev_uniprot-all.txt";	
	my $ResultFileName = $MyLE::dataDir."ID-SL_rev_uniprot-all.txt";
	my $routineName = "SLExtractor";
	
	print "$routineName starts.\n";
	
	my $objPB = new MyProgressBar;
	$objPB->setAll($DBFilename);
	
	open DB,$DBFilename or die "No file";
	
	open RF, ">$ResultFileName";
	
	while(<DB>){
		$objPB->nowAndPrint($.);
		
		if(m/^ID/){
			print RF;
		}elsif(m/^CC   -!- SUBCELLULAR LOCATION/){
			print RF;
			while(<DB>){
				$objPB->nowAndPrint($.);
				
				if(m/^CC   ------/){
					last;
				}elsif(!m/-!-/){
					print RF;
				}elsif(m/^CC   -!- SUBCELLULAR LOCATION/){
					print RF;
				}else{
					last;
				}
			}
		}elsif(m/^\/\//){
			print RF;
		}
	}
	print "$routineName ends\n";
	close DB;	close RF;
	
	printf("%0.3f\n",Time::HiRes::time - $startTime); 
}

sub GOExtractor{
	my $startTime = Time::HiRes::time();
	my $DBFilename = $MyLE::dataDir."rev_uniprot-all.txt";
	my $ResultFileName = $MyLE::dataDir."ID-GO_rev_uniprot-all.txt";
	my $routineName = "GOExtractor";
	
	print "$routineName starts.\n";
	
	my $objPB = new MyProgressBar;
	$objPB->setAll($DBFilename);
	
	open DB,$DBFilename or die "No file";
	
	open RF, ">$ResultFileName";
	
	while(<DB>){
		$objPB->nowAndPrint($.);
		
		if(m/^ID/){
			print RF;
		}elsif(m/^DR   GO/){
			print RF;
		}elsif(m/^\/\//){
			print RF;
		}
	}
	print "$routineName ends\n";
	close DB;	close RF;
	
	printf("%0.3f\n",Time::HiRes::time - $startTime); 
}

sub GOContentExtractor{
	my $startTime = Time::HiRes::time();
	my $DBFilename = $MyLE::dataDir."ID-GO_rev_uniprot-all.txt";
	my $ResultFileName = $MyLE::listDir."GOContetnts.txt";
	my $routineName = "GOContentExtractor";
	
	my @buf;
	my @contents=();
	my $content;
	my $location;
	my $exist;
	
	my $objPB = new MyProgressBar;
	
	print "$routineName starts.\n";
	
	open DB,$DBFilename or die "No file";

	$objPB->setAll($DBFilename);

	open RF, ">$ResultFileName";
	
	while(<DB>){
		$objPB->nowAndPrint($.);
		
		if(m/^DR/){
			@buf = split(";");
			if($buf[2] =~ m/^ C/){
				$location = substr($buf[2],3);
				
				$exist = 0;
				foreach $content (@contents){
					if($location eq $content){
						$exist = 1;
						last;
					}
				}
				
				if($exist == 0){
					push (@contents, $location);
				}
			}
		}
	}
	
	foreach $content (@contents){
		print RF "$content\n";
	}
	
	print "$routineName ends\n";
	close DB;	close RF;
	
	printf("%0.3f\n",Time::HiRes::time - $startTime); 
}

sub FTKeyExtractor{
	my $startTime = Time::HiRes::time();
	my $DBFilename = $MyLE::dataDir."ID-FT_rev_uniprot-all.txt";
	my $ResultFileName = $MyLE::listDir."FT_Keys.txt";	
	my $routineName = "FTKeyExtractor";
	
	my @keys=();
	my $thisKey;
	my $key;
	my $exist;
	
	print "$routineName starts\n";
	
	my $objPB = new MyProgressBar;
	
	open DB,$DBFilename or die "No file";
	
	$objPB->setAll($DBFilename);
	
	open RF, ">$ResultFileName" or die "Cannot Create a Result File.";
	
	while(<DB>){
		$objPB->nowAndPrint($.);
		
		if(m/^FT/){
			$thisKey = substr($_,5,8);
			$thisKey =~ tr/ //d;
			
			if($thisKey eq ""){next;}
			
			$exist = 0;
			foreach $key (@keys){
				if($key eq $thisKey){
					$exist = 1;
					last;
				}
			}
			
			if($exist == 0){
				push (@keys, $thisKey);
			}
		}
	}
	
	foreach $key (@keys){
		print RF "$key\n";
	}
	
	print "$routineName ends\n";
	close DB;	close RF;
	
	printf("%0.3f\n",Time::HiRes::time - $startTime); 
}

sub FTLipidFeaturesExtractor{
	my $startTime = Time::HiRes::time();
	my $DBFilename = $MyLE::dataDir."ID-FT_rev_uniprot-allFlat.txt";
	my $ResultFileName = $MyLE::listDir."FT_Lipid_Features.txt";
	my $routineName = "FTLipidFeaturesExtractor";
	
	my @features=();
	my $thisFeature;
	my $feature;
	my $exist;
	
	print "$routineName starts\n";
	
	my $objPB = new MyProgressBar;
	
	open DB,$DBFilename or die "No file";
	
	$objPB->setAll($DBFilename);
	
	open RF, ">$ResultFileName";
	
	while(<DB>){
		$objPB->nowAndPrint($.);
		
		if(m/^FT   LIPID/){
			$thisFeature = substr($_,34);
			$thisFeature =~ m/(.+?)[\.;]/;
			$thisFeature = $1;
			if($thisFeature eq ""){next;}
			
			$exist = 0;
			foreach $feature (@features){
				if($feature eq $thisFeature){
					$exist = 1;
					last;
				}
			}
			
			if($exist == 0){
				push (@features, $thisFeature);
			}
		}
	}
	
	foreach $feature (@features){
		print RF "$feature\n";
	}
	
	print "$routineName ends\n";
	close DB;	close RF;
	
	printf("%0.3f\n",Time::HiRes::time - $startTime); 
}

sub FTOneLiner{
### This subroutine makes each Kye of FT one line.

	my $startTime = Time::HiRes::time();
	
	my $DBFilename = $MyLE::dataDir."ID-FT_rev_uniprot-all.txt";
	my $ResultFileName = $MyLE::dataDir."ID-FT_rev_uniprot-allFlat.txt";
	my $routineName = "FTOneLiner";
	
	my $workingLine="";
	my $nextLine;
	my $workingKey;
	my $nextKye;
	
	print "$routineName starts.\n";
	
	my $objPB = new MyProgressBar;
	
	open DB,$DBFilename or die "No file";
	
	$objPB -> setAll($DBFilename);
	
	open RF, ">$ResultFileName";
	
	while(<DB>){
		$objPB->nowAndPrint($.);
		
		if(m/^ID/){print RF;}
		elsif(m/^\/\//){print RF;}
		else{
			$workingLine = $_;
			
			while(<DB>){
				$objPB->nowAndPrint($.);
				
				if(m/^\/\//){
					print RF $workingLine;
					print RF;
					last;
				}
				
				$workingKey = substr($_,5,8);
				$workingKey =~ tr/ //d;
				
				if($workingKey eq ""){
					chomp($workingLine);
					$nextLine = substr($_,34);
					
					if(substr($workingLine,-1) eq "-"){
						$workingLine = $workingLine.$nextLine;
					}else{
						$workingLine = $workingLine." ".$nextLine;
					}
				}else{
					print RF $workingLine;
					$workingLine = $_;
				}
			}
		}
		
	}
	print "$routineName ends\n";
	close DB;	close RF;
	
	printf("%0.3f\n",Time::HiRes::time - $startTime); 
}

1;