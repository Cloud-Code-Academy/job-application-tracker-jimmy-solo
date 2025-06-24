trigger EventTrigger on Event (before insert) {
    new EventTriggerHandler().run();
}