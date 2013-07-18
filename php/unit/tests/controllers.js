describe('iPymeApp.controllers', function() {
    var $routeParams = {path: ''},
    $location = {
        path: function(pathvalue) {
            $routeParams.path = pathvalue;
        },
        absUrl: function() {
            return $routeParams.path;
        }
    }
    var ipymeajax, $scope, $httpBackend;
    
    beforeEach(module('iPymeApp'));

    describe('MainMenuController', function() {
        beforeEach(inject(function($rootScope, $injector) {
            ipymeajax = $injector.get('ipymeajax');
            $scope = $rootScope.$new();
            $httpBackend = $injector.get('$httpBackend');
        }));

        afterEach(function() {
            $httpBackend.verifyNoOutstandingExpectation();
            $httpBackend.verifyNoOutstandingRequest();
        });

        it('Dectects changes on $location.path - $scope.adminpanel should be 1 when /admin is on ther url', inject(function($controller) {
            $httpBackend.whenPOST('http://server/backend.php/shop/menu/main').respond({valid_session: 0});
            $controller('MainMenuController', {
                $scope: $scope,
                ipymeajax: ipymeajax,
                $routeParams: $routeParams,
                $location: $location
            });
            $httpBackend.flush();
            
            $location.path('bbb');
            $scope.$apply();
            expect($scope.adminpanel).toEqual(0);

            $location.path('/admin/aaaaaaaaa');
            $scope.$apply();
            expect($scope.adminpanel).toEqual(1);

            $location.path('/admin');
            $scope.$apply();
            expect($scope.adminpanel).toEqual(1);

            $location.path('/admddin');
            $scope.$apply();
            expect($scope.adminpanel).toEqual(0);

            $location.path('/user');
            $scope.$apply();
            expect($scope.adminpanel).toEqual(0);
        }));
    });

    describe('CarouselItemsCtrl', function() {
        beforeEach(inject(function($rootScope, $injector) {
            ipymeajax = $injector.get('ipymeajax');
            $scope = $rootScope.$new();
            $httpBackend = $injector.get('$httpBackend');
        }));

        afterEach(function() {
            $httpBackend.verifyNoOutstandingExpectation();
            $httpBackend.verifyNoOutstandingRequest();
        });

        describe('No valid session', function() {
            it('No valid session, then redirect to /user/signin', inject(function($controller) {
                $httpBackend.whenPOST('http://server/backend.php/shop/product/getDisplayedProductsByCategory/-1').respond({valid_session: 0});
                $controller('CarouselItemsCtrl', {
                    $scope: $scope,
                    $location: $location,
                    $element: 3,
                    ipymeajax: ipymeajax,
                    imageSourceHost: 4
                });

                $httpBackend.flush();
                expect($location.absUrl()).toEqual('/user/signin');
            }));
        });


        describe('Displayed products received, so slides should be populated', function() {
            it('Slide is populated with the products received', inject(function($controller) {
                $httpBackend.whenPOST('http://server/backend.php/shop/product/getDisplayedProductsByCategory/-1').respond({displayedProducts: [{image_path: 1
                                    , id: 2
                                    , description: 3
                                    , longDescription: 4
                                    , price: 5}]});
                $controller('CarouselItemsCtrl', {
                    $scope: $scope,
                    $location: $location,
                    $element: 3,
                    ipymeajax: ipymeajax,
                    imageSourceHost: 4
                });
                $httpBackend.flush();
                expect($scope.slides[0].image).toEqual(1);
                expect($scope.slides[0].id).toEqual(2);
                expect($scope.slides[0].description).toEqual(3);
                expect($scope.slides[0].longdescription).toEqual(4);
                expect($scope.slides[0].price).toEqual(5);
            }));
        });
    });
});
