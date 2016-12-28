window.React = require('react');

import ReactDOM from 'react-dom';
window.ReactDOM = ReactDOM;

import Statistics from './components/statistics/statistics';
import Teams from './components/teams/teams';
import Projects from './components/projects/projects';
import Users from './components/users/users';
import UserSkillRates from './components/skills/user_skill_rates';
import UserSkillTimeline from './components/skills/user_skill_timeline';
import Scheduling from './components/scheduling/scheduling';

registerComponent('statistics', Statistics);
registerComponent('teams', Teams);
registerComponent('projects', Projects);
registerComponent('users', Users);
registerComponent('user_skill_rates', UserSkillRates);
registerComponent('user_skill_timeline', UserSkillTimeline);
registerComponent('scheduling', Scheduling);
