import React from 'react';
import UserSkillHistoryFilter from './user_skill_history_filter';
import UserSkillHistoryTimeline from './user_skill_history_timeline';

export default class UserSkillHistory extends React.Component {
    cssNamespace = 'user-skill-history'

    activeCategory = 0
    skillCategories = [
        {
            name: 'backend',
            isActive: true
        },
        {
            name: 'devops',
            isActive: false
        },
        {
            name: 'ios',
            isActive: false
        },
        {
            name: 'frontend',
            isActive: false
        },
        {
            name: 'design',
            isActive: false
        },
        {
            name: 'android',
            isActive: false
        },
    ]

    constructor(props) {
        super(props);

        this.state = {skillCategories: this.skillCategories, tom: 'test'};
        this.changeActiveCategory = this.changeActiveCategory.bind(this);
    }

    changeActiveCategory(index) {
        const skillCategories = $.extend({}, this.state.skillCategories);
        
        skillCategories[this.activeCategory].isActive = false;
        skillCategories[index].isActive = true;
        
        this.setState(skillCategories);
        this.activeCategory = index;
    }
    
    render() {
        return (
            <div>
                <UserSkillHistoryFilter
                    cssNamespace = {`${this.cssNamespace}-filter`}
                    listPrimaryText='Skill categories:'
                    listItems={this.state.skillCategories}
                    tom={this.state.tom}
                    onItemClick={this.changeActiveCategory}
                />
                <UserSkillHistoryTimeline />
            </div>
        );
    }
}
