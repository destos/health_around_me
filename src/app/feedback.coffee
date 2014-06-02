# Handle feedback forms and such.

class LocationRoutes extends Config
    constructor: ($stateProvider, $urlRouterProvider) ->
        $urlRouterProvider
            .when('/f', '/feedback')

        $stateProvider
            # Basic feedback form
            .state('feedback',
                url: '/feedback'
                controller: 'feedbackController'
                templateUrl: 'feedback.html'
            )
            # Handle sending feedback related to a specific score
            .state('deedback.score',
                url: '/:score_slug'
                controller: 'feedbackController'
                templateUrl: 'feedback.html'
            )

class Feedback extends Controller
    constructor: ($scope, $state, $stateParams) ->
        # do da feedbacks
