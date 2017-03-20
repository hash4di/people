import React from 'react';
import UserSkillHistoryFilter from './user_skill_history_filter';
import {shallow} from 'enzyme';
import renderer from 'react-test-renderer';

test('component structure match snapshot', () => {
  const cssNamespace = 'test-subject';
  const subject = renderer.create(
    <UserSkillHistoryFilter cssNamespace={cssNamespace} />
  );

  expect(subject.toJSON()).toMatchSnapshot();
});

test('component structure without any parameter match snapshot', () => {
  const subject = renderer.create(<UserSkillHistoryFilter />);
  expect(subject.toJSON()).toMatchSnapshot();
});

test('component structure with all parameters match snapshot', () => {
  const cssNamespace = 'test-subject';
  const listPrimaryText = 'My test list';
  const startDate = '2016-12-01';
  const endDate = '2016-12-12';
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
  const component = (
    <UserSkillHistoryFilter
      cssNamespace={cssNamespace}
      listItems={listItems}
      listPrimaryText={listPrimaryText}
      startDate={startDate}
      endDate={endDate}
    />
  );
  const subject = shallow(component);

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
  });

  expect(renderer.create(component).toJSON()).toMatchSnapshot();
});
