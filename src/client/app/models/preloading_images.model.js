(function () {
    'use strict';

    angular
        .module('app.core')
        .factory('PreloaderModel', PreloaderModel);

    PreloaderModel.$inject = [];
    /* @ngInject */
    function PreloaderModel() {
        var preloader;

        preloader = {
            api: {
                preloadImages: preloadImages
            }
        };

        return preloader;

        function preloadImages(imgs, path, callback) {
            var img;
            var remaining = imgs.length;

            function handling() {
                --remaining;
                if (remaining <= 0) {
                    callback();
                }
            }

            for (var i = 0; i < imgs.length; i++) {
                img = new Image();
                img.src = imgs[i][path];
                img.onload = handling;
                img.onerror = handling;
            }
        }
    }
})();
