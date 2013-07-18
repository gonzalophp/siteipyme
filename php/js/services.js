'use strict';

/* Services */

angular.module('iPymeApp.services')
.factory('backendSourceHost',function($location){return 'http://'+$location.host()+'/backend.php'})
.factory('imageSourceHost',function($location){return 'http://'+$location.host()+'/img'})
.factory('getParentByTagName',function() { 
    return function(childNode,tagName){
        for (var node=childNode; node.nodeName!==tagName; node=node.parentNode);
        return node;
    }
})
.factory('ipymeajax', function($http,backendSourceHost ) {
    return function(url, postdata, undefined_content){
        var xhr_options = {withCredentials : true}
        if (undefined_content) {
            xhr_options.transformRequest = angular.identity;
            xhr_options.headers = {'Content-Type': undefined}
        }
        else {
            xhr_options.headers = {'Content-Type': 'application/x-www-form-urlencoded'}
        }
        return $http.post(backendSourceHost+url, postdata, xhr_options);
    }
})
.factory('buttonset', function() {
    return function(buttons){
        var aAvailableButtons = {save:  {action: "save",class: "btn-primary",displayName: "Save"},
                                 cancel:{action: "cancel",class: "btn-default",displayName: "Cancel"},
                                 delete:{action: "delete",class: "btn-danger",displayName: "Delete"},},
            aButtonSet =[];
        for(var key in buttons) {
            aButtonSet.push(aAvailableButtons[buttons[key]]);
        }
        return aButtonSet;
    }
})

.factory('opendialog', function($dialog) {
    return function($scope,aData, start_empty, form_template, buttons, readonly, objecttarget){
            var dialog = $dialog.dialog({templateUrl: 'tpl/forms/ng.'+form_template+'.tpl',
                                     controller: 'FormDialogController'});

        dialog.buttons=buttons;
        dialog.readonly=readonly;
        dialog.formContext = 'user/'+form_template;
        dialog.data = aData;
        dialog.open().then(function(oReturn) {
            if (oReturn && oReturn.success == 1) {
                if (oReturn.button == 1){
                    if (form_template == 'address') {
                        if (start_empty==1) {
                            if ($scope.model.user_details.addresses.length > 0)
                            $scope.model.user_details.addresses.push(oReturn.response.address);
                            else $scope.model.user_details.addresses=[oReturn.response.address];
                            $scope.model.user_details[objecttarget] = oReturn.response.address;
                        }
                        $scope.model.user_details[objecttarget].address_detail_ad_country = oReturn.response.address.address_detail_ad_country;
                    }
                    if (form_template == 'card') {
                        if (start_empty==1) {
                            $scope.model.user_details.card.push(oReturn.response.card);
                            $scope.model.user_details[objecttarget] = oReturn.response.card;
                        }
                    }

                    if (form_template == 'account') {
                        $scope.model.user_details.people_selected = oReturn.response.people;
                    }
                }
                else if (oReturn.button == 2){
                }
            }
        });
    }
})

;
 