<?php
class Sudoku {
    public $aSudoku;
    
    public function initializeSudoku(){
        $this->aSudoku = array();
        for($nLine=1;$nLine<10;$nLine++){
            $this->aSudoku[$nLine] = array();
            for($nColumn=1;$nColumn<10;$nColumn++){
                $this->aSudoku[$nLine][$nColumn] = NULL;
            }
        }
    }
    
    function drawSudoku(){
        for($nLine=1;$nLine<10;$nLine++){
            if (($nLine % 3) == 1) echo "\n";
            for($nColumn=1;$nColumn<10;$nColumn++){
                if (is_null($this->aSudoku[$nLine][$nColumn])){
                    echo ". ";
                }
                else {
                    echo $this->aSudoku[$nLine][$nColumn] . " ";
                }
                if ((($nColumn+1) % 3) == 1) echo "  ";
            }
            echo "\n";
        }
    }
    
    function getTakenNumbersAtLine($nLine){
        $aTakenNumbersAtLine = array();
        for($nColumn=1;$nColumn<10;$nColumn++){
            if (!is_null($this->aSudoku[$nLine][$nColumn])){
                $aTakenNumbersAtLine[] = $this->aSudoku[$nLine][$nColumn];
            }
        }
        return $aTakenNumbersAtLine;
    }
    
    function getTakenNumbersAtColumn($nColumn){
        $aTakenNumbersAtColumn = array();
        for($nLine=1;$nLine<10;$nLine++){
            if (!is_null($this->aSudoku[$nLine][$nColumn])){
                $aTakenNumbersAtColumn[] = $this->aSudoku[$nLine][$nColumn];
            }
        }
        
        return $aTakenNumbersAtColumn;
    }
    
    function getCubePositions($nCubeNumber){
        $nCubeColumnOffset = 3 * (($nCubeNumber-1) % 3);
        $nCubeLineOffset = 3 * ((int)(($nCubeNumber-1) / 3));
        
        $aCubePositions = array();
        for ($nLine=1;$nLine<4;$nLine++){
            for ($nColumn=1;$nColumn<4;$nColumn++){
                $aCubePosition = array('L' => ($nCubeLineOffset+$nLine)
                                     , 'C' => ($nCubeColumnOffset+$nColumn));
                
                $aTakenNumbersAtLine = $this->getTakenNumbersAtLine($aCubePosition['L']);
                $aTakenNumbersAtColumn = $this->getTakenNumbersAtColumn($aCubePosition['C']);
                $aMergeTakenNumbers = array_unique(array_merge($aTakenNumbersAtLine, $aTakenNumbersAtColumn));
                $aCubePosition['available'] = array_diff(array(1,2,3,4,5,6,7,8,9), $aMergeTakenNumbers);
                
                $aCubePositions[((3*($nLine-1))+$nColumn)] = $aCubePosition;
            }
        }
        
        return $aCubePositions;
    }
    
    function resetCube($aCubePositions){
        foreach($aCubePositions as $aCubePosition){
            $this->aSudoku[$aCubePosition['L']][$aCubePosition['C']] = NULL;
        }
    }
    
    function getMinimalAvailablePositions($aCubePositions){
        $aMinimalAvailablePositions = NULL;
        for($i=count($aCubePositions); $i>0; $i--){
            if (is_null($this->aSudoku[$aCubePositions[$i]['L']][$aCubePositions[$i]['C']])){
                if (is_null($aMinimalAvailablePositions)){
                    $aMinimalAvailablePositions = $aCubePositions[$i];
                }
                else {
                    $nNumbersAvailable = count($aCubePositions[$i]['available']);
                    $nMinimalAvailable = count($aMinimalAvailablePositions['available']);
                    if (($nNumbersAvailable < $nMinimalAvailable) && ($nNumbersAvailable>0)) {
                        $aMinimalAvailablePositions = $aCubePositions[$i];
                    }
                }
            }
        }
        return $aMinimalAvailablePositions;
    }
    
    function fillSudoku(){
        for($nCube=1; $nCube<10;$nCube++){
            $aCubePositions = $this->getCubePositions($nCube);
            
            for($n = 1; $n<10; $n++){
                $aMinimalAvailablePositions = $this->getMinimalAvailablePositions($aCubePositions);
                
                if (is_array($aMinimalAvailablePositions['available']) && (count($aMinimalAvailablePositions['available'])>0)){
                    $nNumberChosenIndex = array_rand($aMinimalAvailablePositions['available']);
                }
                else {
                    $this->resetCube($aCubePositions);
                    $nCube = ($nCube>5) ? $nCube-2:$nCube-1;
                    break;
                }
                
                $nNumberChosen = $aMinimalAvailablePositions['available'][$nNumberChosenIndex];
                
                for($i=count($aCubePositions); $i>0; $i--){
                    $aCubePositions[$i]['available'] = array_diff($aCubePositions[$i]['available'],array($nNumberChosen));
                }
                
                $this->aSudoku[$aMinimalAvailablePositions['L']][$aMinimalAvailablePositions['C']] = $nNumberChosen;
            }
        }
    }
    
    function randomSeed(){
        list($usec, $sec) = explode(' ', microtime());
        srand((float) $sec + ((float) $usec * 100000));
    }
    
    public function generateSudoku(){
        $this->randomSeed();
        $this->initializeSudoku();
        $this->fillSudoku();
        return $this;
    }
    
    public function removePositions($nNumberPositions){
        while($nNumberPositions>0){
            $nLine = rand(1,9);
            $nColumn = rand(1,9);
            if (!is_null($this->aSudoku[$nLine][$nColumn])){
                $this->aSudoku[$nLine][$nColumn] = NULL;
                $nNumberPositions--;
            }
            else {
                $this->randomSeed();
            }
        }
    }
}

$oSudoku = new Sudoku();
$oSudoku->generateSudoku();
//$oSudoku->drawSudoku();

//$oSudoku->removePositions(55);
//$oSudoku->drawSudoku();
echo json_encode($oSudoku->aSudoku);