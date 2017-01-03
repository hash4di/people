import React from 'react';

export default class UserSkillHistoryFilter extends React.Component {    
    render() {
        const {cssNamespace, listItems, listPrimaryText, onItemClick} = this.props;

        const listElements = listItems.reduce((acc, listItem, index) => {
            return acc.concat(<li
                    className={listItem.isActive ? `${cssNamespace}__active-item` : ''}
                    onClick={() => {onItemClick(index);}}
                >{listItem.name}</li>
            );
        }, []);

        return <ul className={`${cssNamespace} nav nav-tabs`}>
            <li className="text-primary">{listPrimaryText}</li>
            {listElements}
        </ul>;
    }
}
