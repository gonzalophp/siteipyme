describe('iPymeApp.services', function() {
    var backendSourceHost,
        imageSourceHost,
        buttonset,
        ipymeajax;
    
     beforeEach(function () {
        module('iPymeApp.services');
        
        inject(function($injector) {
            backendSourceHost = $injector.get('backendSourceHost');
            imageSourceHost = $injector.get('imageSourceHost');
            buttonset = $injector.get('buttonset');
            ipymeajax = $injector.get('ipymeajax');
        });
    });
    
    it('services exists', function() {
        expect(backendSourceHost).not.toBe(undefined);
        expect(imageSourceHost).not.toBe(undefined);
    });

    it('backend source host', function() {
        expect(backendSourceHost).not.toBeNull();  
        expect(backendSourceHost).toEqual('http://server/backend.php');  
    });
    
    it('buttonset', function() {
        expect(buttonset(['save'])).toEqual([{action: "save",class: "btn-primary",displayName: "Save"}]);  
        expect(buttonset(['cancel'])).toEqual([{action: "cancel",class: "btn-default",displayName: "Cancel"}]);  
        expect(buttonset(['delete'])).toEqual([{action: "delete",class: "btn-danger",displayName: "Delete"}]);  
        expect(buttonset(['save', 'cancel'])).toEqual([{action: "save",class: "btn-primary",displayName: "Save"}
                                                        ,{action: "cancel",class: "btn-default",displayName: "Cancel"}]);  
        expect(buttonset(['save', 'delete'])).toEqual([{action: "save",class: "btn-primary",displayName: "Save"}
                                                        ,{action: "delete",class: "btn-danger",displayName: "Delete"}]);  
        expect(buttonset(['cancel', 'delete'])).toEqual([{action: "cancel",class: "btn-default",displayName: "Cancel"}
                                                        ,{action: "delete",class: "btn-danger",displayName: "Delete"}]);
        expect(buttonset(['cancel', 'save', 'delete'])).toEqual([{action: "cancel",class: "btn-default",displayName: "Cancel"}
                                                                ,{action: "save",class: "btn-primary",displayName: "Save"}
                                                                ,{action: "delete",class: "btn-danger",displayName: "Delete"}]);
    });
    
//    it('ipymeajax', function() {
//        expect(ipymeajax(url, postdata, undefined_content).toEqual([{action: "save",class: "btn-primary",displayName: "Save"}]);  
//        expect(buttonset(['cancel'])).toEqual([{action: "cancel",class: "btn-default",displayName: "Cancel"}]);  
//        expect(buttonset(['delete'])).toEqual([{action: "delete",class: "btn-danger",displayName: "Delete"}]);  
//        expect(buttonset(['save', 'cancel'])).toEqual([{action: "save",class: "btn-primary",displayName: "Save"}
//                                                        ,{action: "cancel",class: "btn-default",displayName: "Cancel"}]);  
//        expect(buttonset(['save', 'delete'])).toEqual([{action: "save",class: "btn-primary",displayName: "Save"}
//                                                        ,{action: "delete",class: "btn-danger",displayName: "Delete"}]);  
//        expect(buttonset(['cancel', 'delete'])).toEqual([{action: "cancel",class: "btn-default",displayName: "Cancel"}
//                                                        ,{action: "delete",class: "btn-danger",displayName: "Delete"}]);
//        expect(buttonset(['cancel', 'save', 'delete'])).toEqual([{action: "cancel",class: "btn-default",displayName: "Cancel"}
//                                                                ,{action: "save",class: "btn-primary",displayName: "Save"}
//                                                                ,{action: "delete",class: "btn-danger",displayName: "Delete"}]);
//    });

});
