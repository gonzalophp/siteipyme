<?php
namespace Shop\Controller;

class CategoryController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function indexAction() {
        $aResponse = array(
            'datagrid' => array(),
            'columnDefs' => array(
                array('field' => "c_id", 'displayName' => "ID", 'width' => 30),
                array('field' => "c_reference", 'displayName' => "Reference", 'width' => 150),
                array('field' => "c_description", 'displayName' => "Description", 'width' => 200),
                array('field' => "c_tax", 'displayName' => "Tax", 'width' => 150),
            )
        );
//        $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
//        $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'get_provider', array(':id' => null));
//            
//        foreach($oResultSet as $aProvider) {
//            $aProvider['grid_id'] = $aProvider['p_id'];
//            $aResponse['datagrid'][] = $aProvider;
//        }

        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    public function newCategoryAction(){
        $aResponse = array(
            'tree' => array(array('title' => "Item 1"
                                    ,'toma' => 'aa'
                                    , 'key' => '__1')
                               ,array('title' => "Item 2"
                                    ,'toma' => 'bb'
                                    ,'isFolder' => true
                                   , 'key' => '__2'
                                    ,'children' => array(
                                        array('title'=>'item 2.1', 'key' => '__21')
                                       ,array('title'=>'item 2.2', 'key' => '__22')
                                       ,array('title'=>'item 2.3', 'key' => '__23')
                                    ))
                               ,array('title' => "Item 3"
                                     ,'toma' => 'cc'
                                   , 'key' => '__3')
                )
            );
        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    public function SaveAction(){
//        if ($this->getRequest()->isXmlHttpRequest()) {
//            $sJSONDataRequest = $this->getRequest()->getContent();
//            $aRequest = (array)json_decode($sJSONDataRequest);
//            
//            
//            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
//            $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'set_provider'
//                    , array( ':p_p_id'              => array_key_exists('p_id',$aRequest)?$aRequest['p_id']:null
//                            ,':p_p_provider_name'   => $aRequest['p_provider_name']
//                            ,':p_ie_id'             => array_key_exists('ie_id',$aRequest)?$aRequest['ie_id']:null
//                            ,':p_ie_legal_id'       => $aRequest['ie_legal_id']
//                            ,':p_ie_invoice_name'   => $aRequest['ie_invoice_name']));
//            
//            $aResponse = $oResultSet->current();
//            if ($oResultSet->count()==1){
//                $aResponse['success'] = ($oResultSet->count()==1)?1:0;
//                $aResponse['grid_id'] = $aResponse['p_id'];
//            }
//            else {
//                $aResponse = array('success' => 0);
//            }
//        }
//        else {
//           $aResponse = array('success' => 0);
//        }
        $aResponse = array('success' => 0);
        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    public function SaveTreeAction(){
        
//        $this->getRequest()->setContent('{"title":null,"key":"_1","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"XXXXXXXXXXX","key":"__1","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false},{"title":"Item 2","key":"__2","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"item 2.1","key":"__21","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false},{"title":"item 2.2","key":"__22","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"item2.2.1","key":"_2","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"item 2.3","key":"__23","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"Item 3","key":"__3","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":true,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"XXXXXXXXXXX","key":"__1","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"toma":"aa"}]}]}]}]}]}]}');
//        $this->getRequest()->getHeaders()->addHeaderLine('X_REQUESTED_WITH','XMLHttpRequest');
       
        
        
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest);
            
            $aTableTree = $this->getTableTree($aRequest);
//            var_dump($aTableTree);
            
            $aTree = $this->getTree($aTableTree);
            
 
                    
                    
                    
//            var_dump($aTree);
            $aResponse = array('tree' =>  $aTree);
//            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
//            $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'set_provider'
//                    , array( ':p_p_id'              => array_key_exists('p_id',$aRequest)?$aRequest['p_id']:null
//                            ,':p_p_provider_name'   => $aRequest['p_provider_name']
//                            ,':p_ie_id'             => array_key_exists('ie_id',$aRequest)?$aRequest['ie_id']:null
//                            ,':p_ie_legal_id'       => $aRequest['ie_legal_id']
//                            ,':p_ie_invoice_name'   => $aRequest['ie_invoice_name']));
//            
//            $aResponse = $oResultSet->current();
//            if ($oResultSet->count()==1){
//                $aResponse['success'] = ($oResultSet->count()==1)?1:0;
//                $aResponse['grid_id'] = $aResponse['p_id'];
//            }
//            else {
//                $aResponse = array('success' => 0);
//            }
        }
        else {
           $aResponse = array('success' => 0);
        }
        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    public function DeleteAction(){
        
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest);
            
            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
            $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'delete_provider'
                    , array( ':p_p_id'              => array_key_exists('p_id',$aRequest)?$aRequest['p_id']:null));
                    
            $aResponse = $oResultSet->current();
            $aResponse['success'] = ($oResultSet->count()==1)?1:0;
        }
        else {
            $aResponse = array('success' => 0);
        }
        
        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    public function testAction() {
        $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
        $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'get_customer', array(':id' => null));
        
        foreach($oResultSet as $aRow) {
            var_dump($aRow);
        }
        exit;
    }
    
    public function getTree($aTableTree){
//        var_dump($aTableTree);
        $sSeparator = ' > ';
        
        $aRoot =  array();
        $aNodeStack = array(&$aRoot);
        $sBaseAndSeparator = $sSeparator;
            
        foreach($aTableTree as $sKey => $sNodePath) {
//            echo "\nNodePath\"$sNodePath\"";
//            echo "\nBaseSeparator\"$sBaseAndSeparator\"";
            if (strpos($sNodePath, $sBaseAndSeparator) !== 0){
                do {
                    $sBaseAndSeparator = substr($sBaseAndSeparator, 0, strrpos($sBaseAndSeparator,$sSeparator));
                } while((strcmp($sBaseAndSeparator, $sSeparator)>0) && (strpos($sNodePath, $sBaseAndSeparator)!==0) && array_pop($aNodeStack));
                
                $sBaseAndSeparator .= $sSeparator;
            }
//            echo "\nBaseSeparator\"$sBaseAndSeparator\"";
            $nBaseAndSeparatorLength = strlen($sBaseAndSeparator);
            $aTree = &$aNodeStack[count($aNodeStack)-1];
            if (strpos($sNodePath, $sSeparator, $nBaseAndSeparatorLength) !== FALSE){
//                        echo "\nBBBBBBChildren";
                $sBaseAndSeparator = substr($sNodePath, 0, strrpos($sNodePath, $sSeparator)).$sSeparator;
//                        echo "\n$sBaseAndSeparator";
                $nBaseAndSeparatorLength = strlen($sBaseAndSeparator);
                $aTree[count($aTree)-1]['children'] = array();
                $aTree = &$aTree[count($aTree)-1]['children'];
                $aNodeStack[] = &$aTree;
            }

//                    echo "\nAAAAASibbling";
//                    echo "\n$sBaseAndSeparator";
            $aTree[] = array('title' => substr($sNodePath, $nBaseAndSeparatorLength)
                             ,'key'   => $sKey);

            
//            var_dump($aRoot);
        }
        
        return $aRoot;
    }
    
    public function getTableTree($aTree){
        $sSeparator = ' > ';
        
        $aTableTree = array();
        $aConvertedTree = $this->fromTreeToTableTree($aTree);
        $nSeparatorLength = strlen($sSeparator);
        foreach($aConvertedTree as $sNode) {
            $nKeySeparator = strrpos($sNode, $sSeparator);
            $sKey       = substr($sNode, $nKeySeparator+$nSeparatorLength);
            $sNodePath  = substr($sNode, 0, $nKeySeparator);
            $aTableTree[$sKey] = $sNodePath;
        }
        sort($aTableTree);
        
        return $aTableTree;
    }
    
    public function fromTreeToTableTree($aTree){
        if (is_array($aTree)) {
            $sTitle = $aTree['title'];
            $aChildren = array_key_exists('children', $aTree) ? $aTree['children']:array();
            $sKey = $aTree['key'];
        }
        else {
            $sTitle = $aTree->title;
            $aChildren = isset($aTree->children)?$aTree->children:array();
            $sKey = $aTree->key;
        }
        
        $aTableTree = array();
        if (!empty($aChildren)){
            if (!is_null($sTitle)) $aTableTree[] = $sTitle. ' > '.$sKey;
            foreach($aChildren as $child){
                $aSub = $this->fromTreeToTableTree($child);
                
                foreach($aSub as $sub){
                    $aTableTree[] = $sTitle. ' > '. $sub;
                }
            }
        }
        else {
            $aTableTree = array($sTitle. ' > '.$sKey);
        }
        
        return $aTableTree;
    }
}
?>