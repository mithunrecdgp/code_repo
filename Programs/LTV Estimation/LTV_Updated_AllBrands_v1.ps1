$DATEINDEX = 20150701; $BRAND = "BR"; $COUNTRY="US"; $TYPE="CALIB";

$PGMMODIFIED=$("\\10.8.8.51\LV0\TANUMOY\DATASETS\FROM HIVE\" + $BRAND + "_" + $DATEINDEX + "_LTV_" + $TYPE + "_TRANSACTION.TXT")
 
ECHO $PGMMODIFIED

$INFILEPATH=$("\\10.8.8.51\LV0\TANUMOY\DATASETS\FROM HIVE\" + $BRAND + "_" + $DATEINDEX + "_LTV_" + $TYPE + "_TRANSACTION_TXT")

ECHO $INFILEPATH

IF (TEST-PATH $PGMMODIFIED)
{
  REMOVE-ITEM $PGMMODIFIED
}
 
$FILES = GET-CHILDITEM $INFILEPATH

ECHO $FILES

FOR ($I=0; $I -LT $FILES.COUNT; $I++) 
{
 $PGM = $FILES[$I].FULLNAME 
    
 ECHO $PGM
    
 IF (TEST-PATH $PGM)
 {
     ECHO (GET-ITEM $PGM).LENGTH
     
     IF ((GET-ITEM $PGM).LENGTH -EQ 0)
     
     {
       REMOVE-ITEM $PGM
         
     }

 }
 
}





$FILES = GET-CHILDITEM $INFILEPATH

ECHO $FILES


FOR ($I=0; $I -LT $FILES.COUNT; $I++) 
{
 $PGM = $FILES[$I].FULLNAME 
    
 ECHO $PGM
    
 IF (TEST-PATH $PGM)
 {
     ECHO (GET-ITEM $PGM).LENGTH
     
     IF ((GET-ITEM $PGM).LENGTH -GT 0)
     
     {
       
    	 IF ($I -EQ 0)
    	 {
    	  (GET-CONTENT $PGM) -REPLACE "\\N", "" | SET-CONTENT $PGMMODIFIED
    	 }
    	 
    	 IF ($I -GT 0)
    	 {
    	  (GET-CONTENT $PGM) -REPLACE "\\N", "" | ADD-CONTENT $PGMMODIFIED
    	 }
    	 
    	 REMOVE-ITEM $PGM
         
     }

 }
 
}