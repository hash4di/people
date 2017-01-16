import {Component} from 'react';

export default class UserSkillHistoryLoadingState extends Component {
  quotes = [
    '640K ought to be enough for anybody',
    'the architects are still drafting',
    'the bits are breeding',
    'we\'re building the buildings as fast as we can',
    'would you prefer chicken, steak, or tofu?',
    'pay no attention to the man behind the curtain',
    'and enjoy the elevator music',
    'while the little elves draw your map',
    'a few bits tried to escape, but we caught them',
    'and dream of faster computers',
    'would you like fries with that?',
    'checking the gravitational constant in your locale',
    'go ahead -- hold your breath',
    'at least you\'re not on hold',
    'hum something loud while others stare',
    'the server is powered by a lemon and two electrodes',
    'we love you just the way you are',
    'while a larger software vendor in Seattle takes over the world',
    'we\'re testing your patience',
    'as if you had any other choice',
    'don\'t think of purple hippos',
    'follow the white rabbit',
    'why don\'t you order a sandwich?',
    'while the satellite moves into position',
    'the bits are flowing slowly today',
    'dig on the \'X\' for buried treasure... ARRR!',
    'it\'s still faster than you could draw it'
  ]

  prefix = 'Loading, please wait...'

  getRandomQuote() {
    const {quotes} = this;
    return quotes[Math.floor(Math.random() * quotes.length)];
  }

  getMessage() {
    return (
      <div>
        <div>{this.prefix}</div>
        <div>{this.getRandomQuote()}</div>
      </div>
    );
  }

  render() {
    const {cssNamespace, display} = this.props;

    if (!display) return false;
    return (
      <div className={`progress-bar progress-bar-striped active ${cssNamespace}-loading-state`}>
        {this.getMessage()}
      </div>
    );
  }
}
