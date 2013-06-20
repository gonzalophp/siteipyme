<div class="ipymeshop">
    <shoptopbar></shoptopbar>
    <div class="ipymeshopbody" ng-controller="basketCtrl">
        <div class="basket">
            <basketsummary class="basketsummary" persist="basketpersist" ng-model="model"></basketsummary> 
        </div>
        
        <div class="paymentcheckout"  collapse="model.iscollapsed">
            <h4>Invoice Details</h4>
            <table>
                <tbody>
                    <tr>
                        <td>Title</td>
                        <td>
                            {{model.user_details.people_selected.people_p_title}}
                        </td>
                    </tr>
                    <tr>
                        <td>First Name</td>
                        <td>
                        {{model.user_details.people_selected.people_p_name}}
                        </td>
                    </tr>
                    <tr>
                        <td>surname</td>
                        <td>
                                {{model.user_details.people_selected.people_p_surname}}
                        </td>
                    </tr>
                 </tbody>
            </table>
            <hr/>
                <table spectralbutton="addAddress" spectralbuttontext="Add" ng-transclude>
                    <tbody>
                        <tr>
                            <td>Address</td>
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
                    </tbody>
                </table>
            
            <h4>Delivery Details</h4>
            <table>
                <tbody>
                    <tr>
                        <td>Address</td>
                        <td>
                            <select ng-model="model.user_details.address_delivery" ng-options="address.address_detail_ad_description for address in model.user_details.addresses"></select>
                        </td>

                    </tr>
                    <tr>
                        <td>Address Line 1</td>
                        <td>{{model.user_details.address_delivery.address_detail_ad_line1}}</td>
                    </tr>
                    <tr>
                        <td>Address Line 2</td>
                        <td>{{model.user_details.address_delivery.address_detail_ad_line2}}</td>
                    </tr>
                    <tr>
                        <td>Post Code</td>
                        <td>{{model.user_details.address_delivery.address_detail_ad_town}}</td>
                    </tr>
                    <tr>
                        <td>Town</td>
                        <td>{{model.user_details.address_delivery.address_detail_ad_post_code}}</td>
                    </tr>
                    <tr>
                        <td>Country</td>
                        <td><img class="flag flag-{{model.user_details.address_delivery.address_detail_ad_country.country_c_code}}"/> {{model.user_details.address_delivery.address_detail_ad_country.country_c_name}}</td>
                    </tr>
                </tbody>
            </table>
            <h4>Payment Details</h4>
            <table ng-show="model.user_details.address_selected">
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
                </tbody>
            </table>
            <p>
                <button class="shop confirm" ng-click="confirm()">Confirm</button>
            </p>
        </div>
    </div>
</div>