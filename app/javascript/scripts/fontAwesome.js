import { config, library, dom } from "@fortawesome/fontawesome-svg-core";
import { faThumbsUp as faThumbsUpRegular } from "@fortawesome/free-regular-svg-icons";
import { faThumbsUp as faThumbsUpSolid } from "@fortawesome/free-solid-svg-icons";

config.mutateApproach = "sync";
library.add(faThumbsUpRegular, faThumbsUpSolid);
dom.watch();
