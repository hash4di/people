import React from 'react';
import UserSkillHistoryTimeline from './user_skill_history_timeline';
import {shallow} from 'enzyme';

test('render alert message if model is empty', () => {
  const cssNamespace = 'test-subject';
  const subject = shallow(
    <UserSkillHistoryTimeline
      cssNamespace={cssNamespace}
      model={[]}
    />
  );

  expect(subject.find(`.${cssNamespace}--hide`).length).not.toBe(0);
  expect(subject.find('.alert-warning').text()).not.toBeNull();
});

test('show loading state while waiting for model', () => {
  const cssNamespace = 'test-subject';
  const subject = shallow(
    <UserSkillHistoryTimeline
      cssNamespace={cssNamespace}
      loadingState={true}
      model={[]}
    />
  );

  expect(subject.find(`.${cssNamespace}--hide`).length).not.toBe(0);
  expect(subject.find('.alert-warning').length).toBe(0);
});

test('component is build correctly when all attributes are passed', () => {
  const cssNamespace = 'test-subject';
  const startDate = '2016-12-01';
  const endDate = '2016-12-10';
  const containerWidth = 1000;
  const model = [{
    daysOffset: 0,
    maxRate: 3,
    points: [
      {
        days: 4,
        endDate: '2016-12-01',
        favorite: false,
        note: '',
        rate: 0,
        startDate: '2016-12-05'
      },
      {
        days: 5,
        endDate: '2016-12-05',
        favorite: false,
        note: '',
        rate: 1,
        startDate: '2016-12-10'
      }
    ],
    skillName: 'Spree',
    totalDays: 9
  }];
  const subject = shallow(
    <UserSkillHistoryTimeline
      cssNamespace={cssNamespace}
      startDate={startDate}
      endDate={endDate}
      containerWidth={containerWidth}
      model={model}
    />
  );

  expect(subject.find(`.${cssNamespace}`).html()).not.toBeNull();
  expect(subject.find(`.${cssNamespace}__left-column`).html()).not.toBeNull();
  expect(subject.find(`.${cssNamespace}__timeline`).html()).not.toBeNull();
  expect(subject.find(`.${cssNamespace}__timeline svg`).html()).not.toBeNull();
  expect(subject.find(`.${cssNamespace}__legend-popover-entry-point`).text()).toBe(`Legend`);

  model.forEach(({skillName}, index) => {
    expect(subject.find(`.${cssNamespace}__labels-item`).at(index).text()).toBe(skillName);
  });
});


test('scale method respects minimum scale', () => {
  const subject = new UserSkillHistoryTimeline({model: []});

  expect(subject.getSVGwidthScale(1000, 10, 5)).toBe(100);
  expect(subject.getSVGwidthScale(1000, 500, 5)).toBe(5);
});

test('get extra days variants', () => {
  const subject = new UserSkillHistoryTimeline({model: []});

  expect(subject.getExtraDaysForMargin(10)).toBe(5);
  expect(subject.getExtraDaysForMargin(60)).toBe(10);
  expect(subject.getExtraDaysForMargin(100)).toBe(30);
});
