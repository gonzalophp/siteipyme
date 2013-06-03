<?php
namespace Shop\Controller;

class CurrencyController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function getAction() {
        $this->getRequest()->setContent('{}');
        $this->getRequest()->getHeaders()->addHeaderLine('X_REQUESTED_WITH','XMLHttpRequest');
        
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest, true);
            
            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
            $oResultSet = $oDataFunctionGateway->getDataRecordSet(
                'IPYME_FINAL'
                , 'get_currency'
                , array(':p_c_id'  => (array_key_exists('c_id', $aRequest) ? $aRequest['c_id']:null)));
            
            $aCurrencies = array();
            
            foreach($oResultSet as $aRow) {
                $aCurrencies[] = $aRow['c_name'];
            }
        }
        $aResponse = array('success' => 1, 'currencies' => $aCurrencies);
        return new \Zend\View\Model\JsonModel($aResponse);
    }
}
?>
