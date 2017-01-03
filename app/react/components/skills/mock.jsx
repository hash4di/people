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
              isFavourite: false
            },
            {
              days: 20,
              rate: 1,
              isFavourite: false
            },
            {
              days: 10,
              rate: 2,
              isFavourite: false
            },
            {
              days: 30,
              rate: 3,
              isFavourite: false
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
              isFavourite: false
            },
            {
              days: 13,
              rate: 1,
              isFavourite: false
            },
            {
              days: 10,
              rate: 2,
              isFavourite: false
            },
            {
              days: 2,
              rate: 3,
              isFavourite: false
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
              isFavourite: false
            },
            {
              days: 20,
              rate: 1,
              isFavourite: false
            },
            {
              days: 30,
              rate: 1,
              isFavourite: true
            },
            {
              days: 20,
              rate: 1,
              isFavourite: false
            },
            {
              days: 50,
              rate: 2,
              isFavourite: true
            },
            {
              days: 30,
              rate: 1,
              isFavourite: true
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
              isFavourite: false
            },
            {
              days: 80,
              rate: 1,
              isFavourite: false
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
              isFavourite: false
            },
            {
              days: 10,
              rate: 1,
              isFavourite: true
            },
            {
              days: 10,
              rate: 2,
              isFavourite: true
            },
            {
              days: 10,
              rate: 3,
              isFavourite: true
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
              isFavourite: false
            },
            {
              days: 10,
              rate: 1,
              isFavourite: false
            },
            {
              days: 10,
              rate: 2,
              isFavourite: false
            },
            {
              days: 25,
              rate: 3,
              isFavourite: true
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
              isFavourite: false
            },
            {
              days: 20,
              rate: 1,
              isFavourite: false
            },
            {
              days: 30,
              rate: 1,
              isFavourite: false
            },
            {
              days: 20,
              rate: 1,
              isFavourite: true
            },
            {
              days: 30,
              rate: 2,
              isFavourite: true
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
              isFavourite: true
            },
            {
              days: 80,
              rate: 1,
              isFavourite: false
            }
          ]
        }
      ]
    };
  }
};
