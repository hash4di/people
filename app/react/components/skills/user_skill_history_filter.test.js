import React from 'react';
import UserSkillHistoryFilter from './user_skill_history_filter';
import {shallow} from 'enzyme';

test('render component without any parameters', () => {
  const subject = shallow(<UserSkillHistoryFilter />);
  expect(subject.html()).not.toBeNull();
});

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
