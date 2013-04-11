<?php
namespace Shop\Controller;

class ProductController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function indexAction() {
        if ($this->getRequest()->isOptions()) return;
        
        $oProductTable = $this->getServiceLocator()->get('Datainterface\Model\ProductTable');
        $aResult = $oProductTable->select();

        $aResponse = array(
            'datagrid' => array(),
            'columnDefs' => array(
                array('field' => "p_id", 'displayName' => "ID", 'width' => 30, 'pinned' => true),
                array('field' => "p_ref", 'displayName' => "Reference", 'width' => 100),
                array('field' => "p_description", 'displayName' => "Description", 'width' => 150),
                array('field' => "p_size", 'displayName' => "Size", 'width' => 70),
                array('field' => "p_weight", 'displayName' => "Weight", 'width' => 70),
                array('field' => "p_long_description", 'displayName' => "Long Description", 'width' => 200),
            )
        );
        
        foreach($aResult['resultset'] as $oProduct) {
            $aResponse['datagrid'][] = $oProduct;
        }
                        
//        var_dump($aResponse['products']);
//        $aResult = $oProductTable->select(array('u_session'=>session_id()
//                                            ,'u_status' => 1));
//
//        $bAuthenticated = ($aResult['resultset']->count()==1) && $aResult['success'] && ($aResult['error_code']==0);    
//        $aResponse = array('u_valid_session' => ($bAuthenticated ? 1 :0), 'session_id' => session_id());
        
        
//        $aResponse = array('in_product'=>1);
        return new \Zend\View\Model\JsonModel($aResponse);
    }
}
?>