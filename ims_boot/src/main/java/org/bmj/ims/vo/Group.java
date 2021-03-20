package org.bmj.ims.vo;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class Group {
	
	private int groupId,ownLike,likeCount;
	private String name;
	private Date debutDate;
	
}



