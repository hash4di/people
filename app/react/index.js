window.React = require('react');

import ReactDOM from 'react-dom';
window.ReactDOM = ReactDOM;

import Statistics from './components/statistics/statistics';
import Teams from './components/teams/teams';
import Projects from './components/projects/projects';
import Users from './components/users/users';
import UserSkillRates from './components/skills/user_skill_rates';
import UserSkillHistory from './components/skills/user_skill_history';
import Scheduling from './components/scheduling/scheduling';
import NotificationSkillRate from './components/notifications/notification_skill_rate';

registerComponent('statistics', Statistics);
registerComponent('teams', Teams);
registerComponent('projects', Projects);
registerComponent('users', Users);
registerComponent('user_skill_rates', UserSkillRates);
registerComponent('user_skill_history', UserSkillHistory);
registerComponent('scheduling', Scheduling);
registerComponent('notification_skill_rate', NotificationSkillRate);
