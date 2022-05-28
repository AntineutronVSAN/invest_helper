

abstract class GlobalEvent {


}

class BaseRefreshEvent extends GlobalEvent {

}

class BaseInitialEvent extends GlobalEvent {
  final bool isRefresh;
  BaseInitialEvent({this.isRefresh = true});
}


