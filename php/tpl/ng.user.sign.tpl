<div class="ipymedialog">
    <div class="ipymeSignin">
        <table>
            <tr>
                <td ng-controller="CtrlSignin">
                    <p class="ipymeTitle">Registered Users</p>
                    <table>
                        <tbody>
                            <tr><td>User Name:</td><td><input ng-model="user_data.user_name" type="text" value="{{user_data.user_name}}"/></td></tr>
                            <tr><td>Password:</td><td><input ng-model="user_data.user_password" type="password" value="{{user_data.user_password}}"/></td></tr>
                        </tbody>
                    </table>
                    <p><label for="user_remember"><input type="checkbox" ng-model="user_data.user_remember" id="user_remember"/> Remember</label></p>
                    <div class="ipymeButtonsGroup">
                        <button class="ipymeButton" ng-click="click()">Sign In</button>
                        <button class="ipymeButton" ng-click="clear()">Clear User Data</button>
                    </div>
                </td>
                <td ng-controller="CtrlSignUp">
                    <p class="ipymeTitle">New Users</p>
                    <p class="ipymeErrorMessage" ng-model="error_message">{{error_message}}</p>
                    <table>
                        <tbody>
                            <tr><td>User Name:</td><td>         <input type="text"      ng-model="user_data.user_name"  value="{{user_data.user_name}}"/></td></tr>
                            <tr><td>Email:</td><td>             <input type="text"      ng-model="user_data.user_email" value="{{user_email}}"/></td></tr>
                            <tr><td>Password:</td><td>          <input type="password"  ng-model="user_data.user_password"/></td></tr>
                            <tr><td>Retype Password:</td><td>   <input type="password"  ng-model="user_data.user_password2"/></td></tr>
                        </tbody>
                    </table>
                    <div class="ipymeButtonsGroup">
                        <button class="ipymeButton" ng-click="click()">Sign Up</button>
                    </div>
                </td>
            </tr>
        </table>
    </div>
</div>


