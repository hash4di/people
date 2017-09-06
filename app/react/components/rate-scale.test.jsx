import React from 'react';
import RateScale from './rate-scale';
import {shallow, mount } from 'enzyme';

describe('RateScale', () => {

  beforeAll(() => {
    window.$ = function () {
      return {
        tooltip() {
          return 'test';
        }
      }
    }
  });

  describe('when rate type is range', () => {
    const testingComponent = <RateScale
      rate={0}
      rateType={'range'}
      onRateChange={fn => fn}
    />

    test('component structure match snapshot', () => {
      const subject = mount(testingComponent);
      expect(subject).toMatchSnapshot();
    });

    test('clicks on rate element change displayed elements', () => {
      const subject = shallow(testingComponent);
      expect(subject.find('.skill__clear_rate')).toHaveLength(0);
      expect(subject.find('.glyphicon-star-empty')).toHaveLength(3);
      expect(subject.find('.glyphicon-star')).toHaveLength(0);

      subject.find('li').children().first().simulate('click', { currentTarget: { dataset: { rate: 1 } } })

      expect(subject.find('.skill__clear_rate')).toHaveLength(1);
      expect(subject.find('.glyphicon-star-empty')).toHaveLength(2);
      expect(subject.find('.glyphicon-star')).toHaveLength(1);
    });

    test('hover on rate element toggle css classes', () => {
      const subject = shallow(testingComponent);

      expect(subject.find('.hovered')).toHaveLength(0);
      subject.find('li').children().first().simulate('mouseEnter', { currentTarget: { dataset: { rate: 3 } } })
      expect(subject.find('.hovered')).toHaveLength(3);
      subject.find('li').children().first().simulate('mouseLeave')
      expect(subject.find('.hovered')).toHaveLength(0);
    });

  });

  describe('when rate type is boolean', () => {
    const testingComponent = <RateScale
      rate={0}
      rateType={'boolean'}
      onRateChange={fn => fn}
    />

    test('component structure match snapshot', () => {
      const subject = mount(testingComponent);
      expect(subject).toMatchSnapshot();
    });

    test('clicks on rate element change displayed elements', () => {
      const subject = shallow(testingComponent);

      expect(subject.find('.skill__clear_rate')).toHaveLength(0);
      expect(subject.find('.glyphicon-unchecked')).toHaveLength(1);
      expect(subject.find('.glyphicon-check')).toHaveLength(0);

      subject.find('li').children().first().simulate('click', { currentTarget: { dataset: { rate: 1 } } })

      expect(subject.find('.skill__clear_rate')).toHaveLength(1);
      expect(subject.find('.glyphicon-unchecked')).toHaveLength(0);
      expect(subject.find('.glyphicon-check')).toHaveLength(1);
    });

    test('hover on rate element toggle css classes', () => {
      const subject = shallow(testingComponent);

      expect(subject.find('.hovered')).toHaveLength(0);
      subject.find('li').children().first().simulate('mouseEnter', { currentTarget: { dataset: { rate: 1 } } })
      expect(subject.find('.hovered')).toHaveLength(1);
      subject.find('li').children().first().simulate('mouseLeave')
      expect(subject.find('.hovered')).toHaveLength(0);
    });

  });
});
