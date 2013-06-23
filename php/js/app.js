'use strict';

angular.module('iPymeApp.Menu',[]);
angular.module('iPymeApp.services', []);
angular.module('iPymeApp.filters', []);
angular.module('iPymeApp.directives',[]);

// Declare app level module which depends on filters, and services
angular.module('iPymeApp', ['iPymeApp.filters', 'iPymeApp.services', 'iPymeApp.directives','iPymeApp.Menu', 'ngGrid', 'ngCookies','ui.bootstrap','ui.date','ui.select2'])
.config(['$routeProvider', function($routeProvider) {
    $routeProvider
    .when('/admin/list/:list', {
        templateUrl: 'tpl/ng.admin.list.tpl', 
    })
    .when('/admin/category', {
        templateUrl: 'tpl/ng.admin.category.tpl', 
    })
    .when('/admin', {
        redirectTo: '/admin/list/product'
    })
    
        .when('/admin/:_/:_', {redirectTo: '/admin'})
        .when('/admin/:_', {redirectTo: '/admin'})

    .when('/shop', {
        templateUrl: 'tpl/ng.shop.tpl', 
    })
    .when('/shop/product/:id', {
        templateUrl: 'tpl/ng.product.tpl', 
    })
    .when('/user', {
        templateUrl: 'tpl/ng.user.tpl', 
    })
    .when('/user/signin', {
        templateUrl: 'tpl/ng.user.sign.tpl', 
    })
    .when('/user/logout', {
        template: '<span></span>', 
        controller:'logoutCtrl',    
    })
    .when('/user/signup/confirm/:sessionid', {
        templateUrl: 'tpl/ng.user.sign.confirmation.tpl', 
    })
    .when('/basket', {
        templateUrl: 'tpl/ng.basket.tpl', 
    })
    .when('/payment', {
        templateUrl: 'tpl/ng.payment.tpl', 
    })
    .otherwise({
        redirectTo: '/shop'
//        redirectTo: '/test'
    });
}]);

angular.module('iPymeApp')
.run(['$rootScope','$location', function($rootScope,$location){
   $rootScope.model = {user:{u_valid_session: 0 
                            , name:""
                            , admin: 0
                            , initialized:0},
                       location:$location}
}]);