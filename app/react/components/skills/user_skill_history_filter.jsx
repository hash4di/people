import React from 'react';

export default (props) => {
  const {
    listItems = [],
    cssNamespace,
    listPrimaryText,
    onItemClick,
    setDateRange,
    startDate,
    endDate,
    onDateChange
  } = props;

  const listElements = listItems.reduce((acc, listItem, index) => {
    const activeClass = listItem.isActive ? `${cssNamespace}__filter-category-active-item` : '';

    return acc.concat(
      <li
        className={`${cssNamespace}__filter-category-list-item ${activeClass}`}
        onClick={() => {onItemClick(index);}}
      >
        {listItem.name}
      </li>
    );
  }, []);

  return (
    <div className={cssNamespace}>
      <div className={`${cssNamespace}__filter-category`}>
        <div className={`${cssNamespace}__filter-category-primary-text`}>{listPrimaryText}</div>
        <ul className={`${cssNamespace}__filter-category-list nav nav-tabs`}>
          {listElements}
        </ul>
      </div>
      <div className={`${cssNamespace}__filter-date`}>
        <button
          className={`${cssNamespace}__filter-date-button btn btn-primary`}
          onClick={() => setDateRange(1)}
        >
          last month
        </button>
        <button
          className={`${cssNamespace}__filter-date-button btn btn-primary`}
          onClick={() => setDateRange(3)}
        >
          last 3 months
        </button>
        <div className={`${cssNamespace}__filter-date-label`}>From:</div>
        <input
          className={`${cssNamespace}__filter-date-input form-control`}
          type="date"
          value={startDate}
          onChange={(event) => onDateChange('startDate', event.target.value)}
        />
        <div className={`${cssNamespace}__filter-date-label`}>To:</div>
        <input
          className={`${cssNamespace}__filter-date-input form-control`}
          type="date"
          value={endDate}
          onChange={(event) => onDateChange('endDate', event.target.value)}
        />
      </div>
    </div>
  );
}
