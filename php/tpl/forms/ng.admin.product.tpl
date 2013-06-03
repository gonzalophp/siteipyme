<style>
    input.product_price {
        width:5em;
    }
    input.product_currency {
        width:5em;
    }
    
    textarea.product_long_description{
        height:4em;
    }
    
    table.product_details > tbody > tr > td {
        font-weight:bold;
    }
    
    table.product_details > tbody > tr > td:nth-child(1) {
        text-align:right;
        padding-right:1em;
    }
</style>
<div>
    <div class="modal-header">
        <p class="ipymeTitle">Product</p>
    </div>
    <div class="modal-body">
        <table>
            <tr>
                <td>
                    <table class="product_details">
                        <tbody>
                            <tr>
                                <td>Category:</td><td>{{product.categoryselected.category}}</td>
                            </tr>
                            <tr>
                                <td>ID:</td><td>{{dialogForm.data.fields.p_id}}</td>
                            </tr>
                            <tr>
                                <td>Reference:</td><td><input ng-readonly="dialogForm.readonly" type="text" ng-model="dialogForm.data.fields.p_ref"/></td>
                            </tr>
                            <tr>
                                <td>Description:</td><td><input ng-readonly="dialogForm.readonly" type="text" ng-model="dialogForm.data.fields.p_description"/></td>
                            </tr>
                            <tr>
                                <td>Long Description:</td><td><textarea class="product_long_description" ng-readonly="dialogForm.readonly" ng-model="dialogForm.data.fields.p_long_description"></textarea></td>
                            </tr>
                            <tr>
                                <td>Price:</td>
                                <td>
                                    <input class="product_price" ng-readonly="dialogForm.readonly" type="text" ng-model="dialogForm.data.fields.p_price"/>
                                    <input class="product_currency" ng-readonly="dialogForm.readonly" type="text" ng-model="dialogForm.data.fields.c_name" typeahead="currency for currency in dialogForm.data.currencies  | filter:$viewValue ">
                                </td>
                            </tr>
                            <tr>
                                <td>Picture:</td><td><imageupload imagechange="_imagechanged" ng-model="dialogForm.data.fields.p_image_path"></imageupload></td>
                            </tr>
                        </tbody>
                    </table>
                </td>
                <td class="attributevaluelistinput">
                    <div >
                        <p class="ipymeTitle">Tags Values</p>
                        <table>
                            <tbody>
                                <tr ng-repeat="productattribute in dialogForm.data.category_attribute">
                                    <td>{{productattribute.pca_attribute}}</td>
                                    <td><input type="text" ng-model="productattribute.attribute_value_selected" typeahead="attributevalue for attributevalue in productattribute.attribute_values  | filter:$viewValue "></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <div class="modal-footer">
        <button ng-repeat="button_action in dialogForm.button_actions" class="btn {{button_action.class}}" ng-click="do($event,button_action.action)">{{button_action.displayName}}</button>
    </div>
</div>