<?php
namespace Shop\Controller;

class ImageUploadController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function indexAction() {
        $target_path = $_SERVER['DOCUMENT_ROOT'].'/img/'.basename( $_FILES['file']['name']);

        $sTempName = $_FILES['file']['tmp_name'];
                
        move_uploaded_file($_FILES['file']['tmp_name'], $target_path);
        $imagepath = 'http://ipymeback/img/'.basename( $_FILES['file']['name']);
        $aResponse = array('imagepath' => $imagepath);
        return new \Zend\View\Model\JsonModel($aResponse);
    }
}
?>
