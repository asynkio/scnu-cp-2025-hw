#import "@local/hw-template:1.0.0": *

#show: project.with(
  title: "Lab01 ",
  authors: (
    (
      name: "Aksel Shen",
      email: "20234001053@m.scnu.edu.cn",
      affiliation: "South China Normal University",
    ),
  ),
  date: datetime.today().display(),
)

