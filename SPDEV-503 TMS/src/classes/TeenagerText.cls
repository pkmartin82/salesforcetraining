public with sharing class TeenagerText {

    Map<Integer, String> mapResponses = new Map<Integer, String>();
    Integer msgCount = 0;

    public TeenagerText() {
            mapResponses.put(0, 'whatevs');
            mapResponses.put(1, 'lol');
            mapResponses.put(2, 'omg');
            mapResponses.put(3, '?');
            mapResponses.put(4, ':)');
    }

    public String Communicate(String sMsg) {
        System.Debug(sMsg);
        String s = mapResponses.get(msgCount);
        msgCount++;
        if (msgCount > 4) {
            msgCount = 0;
        }
        return s;
    }
}