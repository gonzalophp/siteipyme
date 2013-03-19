<?php
namespace Admin\Controller;

use Zend\Mvc\Controller\AbstractActionController;
use Zend\View\Model\ViewModel;

class UserController extends AbstractActionController {
    function indexAction() {
        parent::indexAction();

        $oResponse = $this->getResponse();
        $oResponse->getHeaders()->addHeaderLine('Content-Type','text/html')
                                ->addHeaderLine('Access-Control-Allow-Origin','*')
                                ->addHeaderLine('Access-Control-Allow-Headers','X-Requested-With');
        
        $oUser = new \stdClass();
        $oUser->name = "Gonzalo";
        $oUser->surname = "Grado";
        
        $oResponse->setContent(\Zend\Json\Json::encode($oUser));
        
        return $oResponse;
    }
    
    function pruebaAction() {
        echo "this is prueba";exit;
    }
}
?>
