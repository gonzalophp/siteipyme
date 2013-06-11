<link rel="stylesheet" href="css/shop.css"/>
<link rel="stylesheet" href="css/flags/flags.css"/>
<div class="ipymeshop">
    <shoptopbar></shoptopbar>
    
    <script type="text/ng-template" id="paneaccount">
        <table>
            <tbody>
                <tr>
                    <td>Title</td>
                    <td>
<!--                        <select ng-model="model.user_details.people[0].people_p_title" ng-options="title for title in model.titles"></select>-->
                        {{model.user_details.people[0].people_p_title}}
                    </td>
                </tr>
                <tr>
                    <td>First Name</td>
                    <td>
                    <!--<input type="text" ng-model="model.user_details.people[0].people_p_name">-->
                    {{model.user_details.people[0].people_p_name}}
                    </td>
                </tr>
                <tr>
                    <td>surname</td>
                    <td>
<!--                        <input type="text" ng-model="model.user_details.people[0].people_p_surname">-->
                            {{model.user_details.people[0].people_p_surname}}
                    </td>
                </tr>
                <tr>
                    <td>Email</td>
                    <td>{{model.user_details.user_u_email}}</td>
                </tr>
                <tr>
                    <td>Home phone</td>
                    <td>
                        <!--<input type="text" ng-model="model.user_details.people[0].people_p_phone">-->
                         {{model.user_details.people[0].people_p_phone}}
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <button class="shop edit" ng-click="editAccount()">Edit</button>
                    </td>
                </tr>
            </tbody>
        </table>
    </script>
    <script type="text/ng-template" id="paneaddress">
        <table>
            <tbody>
                <tr>
                    <td>Address Description</td>
                    <td>
                        <select ng-model="model.user_details.address_selected" ng-options="address.address_detail_ad_description for address in model.user_details.addresses"></select>
                    </td>
                    
                </tr>
                <tr>
                    <td>Address Line 1</td>
                    <td>{{model.user_details.address_selected.address_detail_ad_line1}}</td>
                </tr>
                <tr>
                    <td>Address Line 2</td>
                    <td>{{model.user_details.address_selected.address_detail_ad_line2}}</td>
                </tr>
                <tr>
                    <td>Post Code</td>
                    <td>{{model.user_details.address_selected.address_detail_ad_town}}</td>
                </tr>
                <tr>
                    <td>Town</td>
                    <td>{{model.user_details.address_selected.address_detail_ad_post_code}}</td>
                </tr>
                <tr>
                    <td>Country</td>
                    <td><img class="flag flag-{{model.user_details.address_selected.address_detail_ad_country.country_c_code}}"/> {{model.user_details.address_selected.address_detail_ad_country.country_c_name}}</td>
                </tr>
                <tr>
                    <td colspan="2">
                        <button class="shop new" ng-click="addAddress()">New Address</button>
                        <button class="shop edit" ng-click="editAddress()">Edit</button>
                    </td>
                </tr>
            </tbody>
        </table>
    </script>
    
    <script type="text/ng-template" id="panepayments">
        <table>
            <tbody>
                <tr>
                    <td>Description</td>
                    <td>
                        <select ng-model="model.user_details.card_selected"    ng-options="card.card_c_description                  for card    in model.user_details.card"></select>
                    </td>
                </tr>
                <tr>
                    <td>Card vendor</td>
                    <td>{{model.user_details.card_selected.card_vendor_cv_name}}</td>
                </tr>
                <tr>
                    <td>Name on card</td>
                    <td>{{model.user_details.card_selected.card_c_name}}</td>
                </tr>
                <tr>
                    <td>Card number</td>
                    <td>{{model.user_details.card_selected.card_c_card_number}}</td>
                </tr>
                <tr>
                    <td>Expire:</td>
                    <td>{{model.user_details.card_selected.card_c_expire_date}}</td>
                </tr>
                <tr>
                    <td>Issue number</td>
                    <td>{{model.user_details.card_selected.card_c_issue_numer}}</td>
                </tr>
                <tr>
                    <td colspan="2">
                        <button class="shop new" ng-click="addPayment()">New Card</button>
                        <button class="shop edit" ng-click="editPayment()">Edit</button>
                    </td>
                </tr>
            </tbody>
        </table>
    </script>
    
    <script type="text/ng-template" id="paneorders">
        <div class="gridStyle"  ng-grid="model.orders.ordersGridOptions"></div>
    </script>
    
    <div class="ipymeshopbody" ng-controller="UserController">
        
        <tabs>
            <pane ng-repeat="pane in model.panes" heading="{{pane.title}}" active="pane.active">
                <div ng-include="pane.template"></div>
            </pane>
        </tabs>
    </div>
    <footer>
        <p>2013 - Gonzalo Grado </p>
    </footer>
</div>