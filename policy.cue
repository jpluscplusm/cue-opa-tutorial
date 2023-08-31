package policy

import "list"

tfplan: _ // where we place the plan

_blast_radius: 30
_weights: {
	aws_autoscaling_group: {
		"delete": 100
		"create": 10
		"modify": 1
	}
	aws_instance: {
		"delete": 10
		"create": 1
		"modify": 1
	}
}

_not_aws_iam: {
	type: !="aws_iam"
} | {
	change: actions: ["no-op"]
}

#no_iam: tfplan.resource_changes
#no_iam: [..._not_aws_iam]

#score: {
	int & list.Sum(_by_resource)
	_by_resource: [
		for resource in tfplan.resource_changes
		for action in resource.change.actions
		let score = *_weights[resource.type][action] | 0 {
			{score}
		},
	]
}

#authz: bool
#authz: {
	_score && _no_iam
	_score:  #score < _blast_radius
	_no_iam: #no_iam != _|_
}
