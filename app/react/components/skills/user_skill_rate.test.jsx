import React from 'react';
import UserSkillRate from './user_skill_rate';
import {shallow, mount } from 'enzyme';

describe('UserSkillRate', () => {

  beforeAll(() => {
    window.$ = function () {
      return {
        tooltip() {
          return 'test';
        }
      }
    }
  });

  const testingComponent = <UserSkillRate
    favorite={true}
    note={'test note'}
    rate={1}
    rate_type={'range'}
    name={'test skill name'}
    description={'test skill description'}
    id={12}
  />

  test('component structure match snapshot', () => {
    const subject = mount(testingComponent);
    expect(subject).toMatchSnapshot();
  });

  test('clicks on favorite element updates favorite state', () => {
    const subject = mount(testingComponent);

    expect(subject.state().favorite).toBe(true);
    subject.find('.skill__row__favorite-btn').first().simulate('click')
    expect(subject.state().favorite).toBe(false);
  });

  test('fills note in textarea to change note', () => {
    const subject = mount(testingComponent);
    expect(subject.state().note).toBe('test note');
    subject.find('.skill__note').node.value = 'new note'
    subject.find('.skill__note').simulate('change');
    expect(subject.state().note).toBe('new note');
  });

  test('triggers onRateChange updates rate state', () => {
    const subject = mount(testingComponent);
    expect(subject.state().rate).toBe(1);
    subject.node.onRateChange(2)
    expect(subject.state().rate).toBe(2);
  });
});
