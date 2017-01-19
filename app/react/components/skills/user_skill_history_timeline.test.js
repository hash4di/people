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
/*
test('tbd', () => {
  const cssNamespace = 'test-subject';
  const startDate = '2016-12-01';
  const endDate = '2016-12-10';
  const containerWidth = 200;
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
  console.log(subject.html());
  //console.log(subject.find('.alert-warning'));
  expect(subject.find(`.${cssNamespace}--hide`).length).not.toBe(0);
  expect(subject.find('.alert-warning').text()).not.toBeNull();
});

/*

test('component wrapper has expected structure', () => {
  const cssNamespace = 'test-subject';
  const subject = shallow(
    <UserSkillHistoryFilter cssNamespace={cssNamespace} />
  );

  expect(subject.is('div')).toBeTruthy();
  expect(subject.hasClass(cssNamespace)).toBeTruthy();
  expect(subject.find('> div').length).toBe(2);

  expect(subject
    .find(`.${cssNamespace}__filter-category`)
    .is('div')
  ).toBeTruthy();

  expect(subject
    .find(`.${cssNamespace}__filter-date`)
    .is('div')
  ).toBeTruthy();
});

test('category filter sub-component has expected structure', () => {
  const cssNamespace = 'test-subject';
  const listPrimaryText = "My test list";
  const listItems = [
    {
      name: 'skill_1',
      isActive: true
    },
    {
      name: 'skill_2',
      isActive: false
    },
    {
      name: 'skill_3',
      isActive: false
    }
  ];
  const subject = shallow(
    <UserSkillHistoryFilter
      cssNamespace={cssNamespace}
      listItems={listItems}
      listPrimaryText={listPrimaryText}
    />
  );

  expect(subject
    .find(`.${cssNamespace}__filter-category-primary-text`)
    .is('div')
  ).toBeTruthy();

  expect(subject
    .find(`.${cssNamespace}__filter-category-primary-text`)
    .text()
  ).toBe(listPrimaryText);

  expect(subject
    .find(`.${cssNamespace}__filter-category-list`)
    .is('ul')
  ).toBeTruthy();

  expect(subject
    .find(`.${cssNamespace}__filter-category-list`)
    .hasClass('nav')
  ).toBeTruthy();

  expect(subject
    .find(`.${cssNamespace}__filter-category-list`)
    .hasClass('nav-tabs')
  ).toBeTruthy();

  expect(subject
    .find(`.${cssNamespace}__filter-category-list-item`)
    .length
  ).toBe(listItems.length);

  listItems.forEach(({name, isActive}, index) => {
    const listItem = subject
      .find(`.${cssNamespace}__filter-category-list-item`)
      .at(index);

    if (isActive) {
      expect(
        listItem.hasClass(`${cssNamespace}__filter-category-active-item`)
      ).toBeTruthy();
    } else {
      expect(
        listItem.hasClass(`${cssNamespace}__filter-category-active-item`)
      ).not.toBeTruthy();
    }

    expect(listItem.text()).toBe(name);
  });
});

test('category filter sub-component has expected structure', () => {
  const cssNamespace = 'test-subject';
  const startDate = "2016-10-10";
  const endDate = "2016-12-12";
  const subject = shallow(
    <UserSkillHistoryFilter
      cssNamespace={cssNamespace}
      startDate={startDate}
      endDate={endDate}
    />
  );
  const filterNodes = subject.find(`.${cssNamespace}__filter-date`).children();

  expect(filterNodes.length).toBe(6);
  expect(filterNodes.at(0).is('button'));
  expect(filterNodes.at(0).text()).toBe('last month');

  expect(filterNodes.at(1).is('button'));
  expect(filterNodes.at(1).text()).toBe('last 3 months');

  expect(filterNodes.at(2).is('div'));
  expect(filterNodes.at(2).text()).toBe('From:');

  expect(filterNodes.at(3).is('input'));
  expect(filterNodes.at(3).prop('type')).toBe('date');
  expect(filterNodes.at(3).prop('value')).toBe(startDate);

  expect(filterNodes.at(4).is('div'));
  expect(filterNodes.at(4).text()).toBe('To:');

  expect(filterNodes.at(5).is('input'));
  expect(filterNodes.at(5).prop('type')).toBe('date');
  expect(filterNodes.at(5).prop('value')).toBe(endDate);
});
*/
