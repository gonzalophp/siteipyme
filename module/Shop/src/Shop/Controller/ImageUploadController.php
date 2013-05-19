<?php
namespace Shop\Controller;

class ImageUploadController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function indexAction() {
//        var_dump($_SERVER['DOCUMENT_ROOT'].'/img/');
        
//        if(move_uploaded_file($_FILES['file']['tmp_name'], $target_path)) {
//            echo "The file ".  basename( $_FILES['uploadedfile']['name']). 
//            " has been uploaded";
//        } else{
//            echo "There was an error uploading the file, please try again!";
//        }



//        
//        ["file"]=>
//  array(5) {
//    ["name"]=>
//    string(13) "younameit.jpg"
//    ["type"]=>
//    string(10) "image/jpeg"
//    ["tmp_name"]=>
//    string(14) "/tmp/php8ZI4Dd"
//    ["error"]=>
//    int(0)
//    ["size"]=>
//    int(3156)
//  }
//}
//         var_dump($_FILES);
        $target_path = $_SERVER['DOCUMENT_ROOT'].'/img/'.basename( $_FILES['file']['name']);
//        return new \Zend\View\Model\JsonModel(array('a'=> $_FILES,'b' => $target_path));
        $sTempName = $_FILES['file']['tmp_name'];
//        echo "<br><br>temp: $sTempName <br><br><br>target $target_path <br><br>";
                
        move_uploaded_file($_FILES['file']['tmp_name'], $target_path);
        $imagepath = 'http://ipymeback/img/'.basename( $_FILES['file']['name']);
        $aResponse = array('imagepath' => $imagepath);
        return new \Zend\View\Model\JsonModel($aResponse);
    }
}
?>
