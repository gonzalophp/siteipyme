'use strict';

/* Services */

angular.module('iPymeApp.services')
        .value('backendSourceHost','<?php echo "http://".$_SERVER['SERVER_NAME'] ?>');

angular.module('iPymeApp')
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
    });
 
