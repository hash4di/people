export default {
    getModel(data) {
    // Transform data to presented output
    return {
      meta: {
        maximumDays: 200
      },
      skills: [
        {
          skillName: 'ember',
          totalDays: 100,
          maxRate: 3,
          updates: [
            {
              days: 40,
              rate: 0,
              isFavourite: false,
              note: ''
            },
            {
              days: 20,
              rate: 1,
              isFavourite: false,
              note: 'notka 1'
            },
            {
              days: 10,
              rate: 2,
              isFavourite: false,
              note: 'notka 2'
            },
            {
              days: 30,
              rate: 3,
              isFavourite: false,
              note: ''
            }
          ]
        },
        {
          skillName: 'react',
          totalDays: 30,
          maxRate: 3,
          updates: [
            {
              days: 5,
              rate: 0,
              isFavourite: false,
              note: ''
            },
            {
              days: 13,
              rate: 1,
              isFavourite: false,
              note: ''
            },
            {
              days: 10,
              rate: 2,
              isFavourite: false,
              note: ''
            },
            {
              days: 2,
              rate: 3,
              isFavourite: false,
              note: ''
            }
          ]
        },
        {
          skillName: 'git',
          totalDays: 200,
          maxRate: 3,
          updates: [
            {
              days: 50,
              rate: 0,
              isFavourite: false,
              note: ''
            },
            {
              days: 20,
              rate: 1,
              isFavourite: false,
              note: 'blabla'
            },
            {
              days: 30,
              rate: 1,
              isFavourite: true,
              note: ''
            },
            {
              days: 20,
              rate: 1,
              isFavourite: false,
              note: 'blabla2'
            },
            {
              days: 50,
              rate: 2,
              isFavourite: true,
              note: ''
            },
            {
              days: 30,
              rate: 1,
              isFavourite: true,
              note: ''
            }
          ]
        },
        {
          skillName: 'jira',
          totalDays: 100,
          maxRate: 1,
          updates: [
            {
              days: 20,
              rate: 0,
              isFavourite: false,
              note: ''
            },
            {
              days: 80,
              rate: 1,
              isFavourite: false,
              note: 'awesome'
            }
          ]
        }
      ]
    };
  },

getModel2(data) {
    // Transform data to presented output
    return {
      meta: {
        maximumDays: 100
      },
      skills: [
        {
          skillName: 'php',
          totalDays: 30,
          maxRate: 3,
          updates: [
            {
              days: 0,
              rate: 0,
              isFavourite: false,
              note: 'ooo'
            },
            {
              days: 10,
              rate: 1,
              isFavourite: true,
              note: ''
            },
            {
              days: 10,
              rate: 2,
              isFavourite: true,
              note: 'nie'
            },
            {
              days: 10,
              rate: 3,
              isFavourite: true,
              note: ''
            }
          ]
        },
        {
          skillName: 'rails',
          totalDays: 50,
          maxRate: 3,
          updates: [
            {
              days: 5,
              rate: 0,
              isFavourite: false,
              note: ''
            },
            {
              days: 10,
              rate: 1,
              isFavourite: false,
              note: ''
            },
            {
              days: 10,
              rate: 2,
              isFavourite: false,
              note: ''
            },
            {
              days: 25,
              rate: 3,
              isFavourite: true,
              note: ''
            }
          ]
        },
        {
          skillName: 'docker',
          totalDays: 100,
          maxRate: 3,
          updates: [
            {
              days: 0,
              rate: 0,
              isFavourite: false,
              note: 'utanhu'
            },
            {
              days: 20,
              rate: 1,
              isFavourite: false,
              note: 'utnahuso'
            },
            {
              days: 30,
              rate: 1,
              isFavourite: false,
              note: ''
            },
            {
              days: 20,
              rate: 1,
              isFavourite: true,
              note: ''
            },
            {
              days: 30,
              rate: 2,
              isFavourite: true,
              note: ''
            }
          ]
        },
        {
          skillName: 'toggl',
          totalDays: 100,
          maxRate: 1,
          updates: [
            {
              days: 20,
              rate: 0,
              isFavourite: true,
              note: ''
            },
            {
              days: 80,
              rate: 1,
              isFavourite: false,
              note: ''
            }
          ]
        }
      ]
    };
  },

  getModel3(data) {
    // Transform data to presented output
    return {
      meta: {
        maximumDays: 30
      },
      skills: [
        {
          skillName: 'php',
          totalDays: 30,
          maxRate: 3,
          updates: [
            {
              days: 5,
              rate: 0,
              isFavourite: false,
              note: 'ooo'
            },
            {
              days: 5,
              rate: 1,
              isFavourite: true,
              note: ''
            },
            {
              days: 10,
              rate: 2,
              isFavourite: true,
              note: 'nie'
            },
            {
              days: 10,
              rate: 3,
              isFavourite: true,
              note: ''
            }
          ]
        }
      ]
    };
  },

  getModel4(data) {
    // Transform data to presented output
    return {
      meta: {
        maximumDays: 300
      },
      skills: [
        {
          skillName: 'trello',
          totalDays: 300,
          maxRate: 3,
          updates: [
            {
              days: 50,
              rate: 0,
              isFavourite: false,
              note: 'ooo'
            },
            {
              days: 50,
              rate: 1,
              isFavourite: true,
              note: ''
            },
            {
              days: 100,
              rate: 2,
              isFavourite: true,
              note: 'nie'
            },
            {
              days: 100,
              rate: 3,
              isFavourite: true,
              note: ''
            }
          ]
        }
      ]
    };
  }
};
