'use strict';

/* Filters */

angular.module('iPymeApp.filters')
    .filter('firstcapital', function() {
            return function(input) {
                var first = input[0].toUpperCase();
                return first+input.substr(1);
            }
        }
    );
