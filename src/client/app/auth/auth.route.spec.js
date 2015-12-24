///* jshint -W117, -W030 */
//describe('auth routes', function () {
//    describe('state', function () {
//        var controller;
//        var viewSignIn = 'app/auth/signin.html';
//
//        beforeEach(function() {
//            module('app.auth', bard.fakeToastr);
//            bard.inject('$httpBackend', '$location', '$rootScope', '$state', '$templateCache');
//        });
//
//        beforeEach(function() {
//            $templateCache.put(viewSignIn, '');
//        });
//
//        //bard.verifyNoOutstandingHttpRequests();
//
//        it('should map state signin to url /signin ', function() {
//            expect($state.href('signin', {})).to.equal('/signin');
//        });
//
//        it('should map /signin route to signin View template', function () {
//            expect($state.get('signin').templateUrl).to.equal(viewSignIn);
//        });
//
//        it('of signin should work with $state.go', function () {
//            $state.go('signin');
//            $rootScope.$apply();
//            expect($state.is('signin'));
//        });
//    });
//});
