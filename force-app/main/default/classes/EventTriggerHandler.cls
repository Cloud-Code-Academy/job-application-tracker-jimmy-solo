public with sharing class EventTriggerHandler extends TriggerHandler {

    private List<Event> eventNewList;

    public EventTriggerHandler() {
        this.eventNewList = (List<Event>)Trigger.new;
    }

    @TestVisible
    public override void beforeInsert(){
        EventTriggerHelper.ensureNoOtherInterviewEventsOnTodaysDate(this.eventNewList);
    }
}