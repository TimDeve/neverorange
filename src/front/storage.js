const PROJECTS_KEY = "projects"


export const getProjectsFromStorage = () => {
  try {
    const projects = localStorage.getItem(PROJECTS_KEY)
    return JSON.parse(projects) || []
  } catch(e) {
    return []
  }
}

export const setProjectsInStorage = projects => {
  localStorage.setItem(PROJECTS_KEY, JSON.stringify(projects))
}
