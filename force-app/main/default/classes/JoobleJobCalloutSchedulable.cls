public with sharing class JoobleJobCalloutSchedulable implements Schedulable {
    public void execute(SchedulableContext sc){
        System.enqueueJob(new JoobleJobCalloutQueueable());
    }
}