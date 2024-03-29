% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/url2params.R
\name{url2params}
\alias{url2params}
\title{Get query paramters from URL address}
\usage{
url2params(url, show = TRUE, clip = FALSE, quote = FALSE,
  is_iconv = TRUE, is_return = FALSE)
}
\arguments{
\item{url}{the url of the page to retrieve}

\item{show}{If TRUE, it whill print returned parameter in the console.}

\item{clip}{If TRUE, it will get url string from clipboard}

\item{quote}{If TRUE, params names print in console will use quote.}

\item{is_iconv}{whether convert encoding from utf-8 to gbk}

\item{is_return}{boolean}
}
\description{
Get query paramters from URL address
}
\examples{
url <- "http://elearning.ne.sysu.edu.cn/webapps/discussionboard/do/message?layer=forum&currentUserInfo=***&conf_id=_413_1&numAttempts=1626&type=user_forum&attempt_id=_5918115_1&callBackUrl=\%2Fwebapps\%2Fgradebook\%2Fdo\%2Finstructor\%2FviewNeedsGrading\%3Fcourse_id\%3D_405_1\%26courseMembershipId\%3D_3928655_1\%26outcomeDefinitionId\%3D_114127_1&forum_id=_61110_1&currentAttemptIndex=1&nav=discussion_board_entry&action=collect_forward&origRequestId=0D68B9644B97B73FA532AC7B5119169C.root_1498061370964&user_id=_227280_1&course_id=_405_1&sequenceId=_405_1_0&viewInfo=\%E9\%9C\%80\%E8\%A6\%81\%E8\%AF\%84\%E5\%88\%86&"
param <- url2params(url, is_return = TRUE)
}
