function Resource($http) {
  return function (path, methods) {
    var resource = {};

    if (methods.indexOf('index') !== -1) {
      resource.index = function (success, error) {
        var request = $http.get(path);
        if (success) request.success(success);
        if (error) request.error(error);
        return request;
      };
    }

    if (methods.indexOf('create') !== -1) {
      resource.create = function (data, success, error) {
        var request = $http.post(path, data);
        if (success) request.success(success);
        if (error) request.error(error);
        return request;
      };
    }

    return resource;
  };
}

function Notification(Resource) {
  return Resource('/notifications.json', ['index']);
}

function Message(Resource) {
  return Resource('/messages.json', ['index', 'create']);
}

function NotificationListCtrl($scope, Notification) {
  $scope.toggleNotifications = function () {
    if ($scope.notifications) {
      $scope.notifications = null;
    } else {
      Notification.index(function (notifications) {
          $scope.notifications = notifications;
      });
    }
  };
}

function MessageCtrl($scope, Message) {
  $scope.message = {};

  Message.index(function (messages) {
    $scope.messages = messages;
  });

  $scope.postMessage = function () {
    var data = angular.copy($scope.message);
    Message.create(data, function (message) {
      $scope.message = {};
      $scope.messages.unshift(message);
    });
  };
}

angular.module('sample', [])
    .service('Resource', Resource)
    .service('Notification', Notification)
    .service('Message', Message)
    .controller('NotificationListCtrl', NotificationListCtrl)
    .controller('MessageCtrl', MessageCtrl);

