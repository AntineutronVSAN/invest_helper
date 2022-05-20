

abstract class GlobalEvent {


}

class BaseRefreshEvent extends GlobalEvent {

}

class BaseInitialEvent extends GlobalEvent {

}

/*abstract class GlobalEvent<LE> {
  LE toLocalEvent() => this as LE;

}

abstract class BaseBlocEvent<T> {
  GlobalEvent<T> toGlobalEvent() => this as GlobalEvent<T>;
}

class GlobalInitialEvent<LE> extends GlobalEvent<LE> {

}
class GlobalRefreshEvent<LE> extends GlobalEvent<LE> {

}*/



