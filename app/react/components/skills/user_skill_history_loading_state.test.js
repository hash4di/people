import React from 'react';
import UserSkillHistoryLoadingState from './user_skill_history_loading_state';
import {shallow} from 'enzyme';

test('get random quote', () => {
  const subject = new UserSkillHistoryLoadingState();
  const quotes = subject.quotes;
  const randomQuote = subject.getRandomQuote();

  expect(quotes.indexOf(randomQuote)).toBeGreaterThan(-1);
});

test('component is not rendered when display property is not true', () => {
  const subject = shallow(<UserSkillHistoryLoadingState />);
  expect(subject.html()).toBe(null);
});

test('render component when display property is set to true', () => {
  const subject = shallow(<UserSkillHistoryLoadingState display="true" />);
  expect(subject.html()).not.toBe(null);
});

test('rendered component has expected structure', () => {
  const subject = shallow(<UserSkillHistoryLoadingState display="true" />);

  expect(subject.is('div')).toBeTruthy();
  expect(subject.find('div').length).toBe(4);
  expect(subject.find('> div > div').length).toBe(2);
  expect(subject.find('> div').childAt(0).text()).not.toBeNull();
  expect(subject.find('> div').childAt(1).text()).not.toBeNull();
});

test('component has expected classes', () => {
  const cssNamespace = 'test-subject';
  const subject = shallow(
    <UserSkillHistoryLoadingState display="true" cssNamespace={cssNamespace} />
  );

  expect(subject.hasClass('progress-bar')).toBeTruthy();
  expect(subject.hasClass('progress-bar-striped')).toBeTruthy();
  expect(subject.hasClass('active')).toBeTruthy();
  expect(subject.hasClass(`${cssNamespace}-loading-state`)).toBeTruthy();
});
