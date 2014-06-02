class ScoreRoutes extends Config
    constructor: ($stateProvider, $urlRouterProvider) ->
        $urlRouterProvider
            .when('/s/:lat/:lng/', '/score/:lat,:lng/')

        $stateProvider
            .state('score',
                url: '/score/:lat,:lng/'
                views:
                    '':
                        templateUrl: 'score.html'
                        controller: 'scoreStateController'
                    'header':
                        template: 'Pick'
                # resolve:
                #     score_data: ['scoreService', '$stateParams', (scores, $stateParams) ->
                #         return scores.byLatLng($stateParams)
                #     ]
            )
            .state('score.cards'
                url: 'cards/'
                views:
                    '':
                        templateUrl: 'cards/base.html'
                        controller: 'cardsController'
                    'header':
                        template: 'Cards'
            )

class Cards extends Controller
    constructor: ($scope, $state, $stateParams) ->


class letter_score extends Filter
    constructor: ->
        (score) ->
            # only work with da numbars
            return score if not angular.isNumber(score)
            # take 0 - 1 and select a letter
            try
                ['F','F','F','F','F','F','F','D','C','B','A'][Math.floor(score * 10)]
            catch e
                return score


class Score extends Service
    constructor: ($http) ->
        @byLatLng = (coords) ->
            return $http.jsonp("http://healtharound.me/api/score/#{coords.lat},#{coords.lng}/?format=jsonp&callback=JSON_CALLBACK").then (resp) ->
                return resp.data


class ScoreState extends Controller
    constructor: ($scope, $state, $stateParams, scoreService) ->
        $scope.score_data = scoreService.byLatLng($stateParams)

        $scope.$watch 'score_data', (score_data) ->
            return if not score_data.elements?.length > 0
            debugger
            total_score = 0
            for elm in score_data.elements
                total_score += elm.score
            $scope.score = total_score / score_data.elements.length

        $scope.go_to_interaction = (type) ->
            $state.go("score.#{type}", $stateParams)
