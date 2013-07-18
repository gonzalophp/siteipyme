describe('iPymeApp.filters', function() {
     beforeEach(function () {
        module('iPymeApp.filters');
    });

    it('there is a filter called firstcapital', inject(function($filter) {
        expect($filter('firstcapital')).not.toBeNull();  
    }));

    it('the filter firstcapital converts the first to uppercase', inject(function($filter) {
        expect($filter('firstcapital')('aaaaa')).toEqual('Aaaaa');
        expect($filter('firstcapital')('aaa aaa')).toEqual('Aaa aaa'); 
    }));
});
