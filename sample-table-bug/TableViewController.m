//
//  TableViewController.m
//  fucking-table-bug
//
//  Created by geoffrey thenot on 23/11/2016.
//  Copyright © 2016 tiller. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *items;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = @[ @"item1", @"item2", @"item3", @"item4", @"item5", @"item6", @"item7"];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    cell.textLabel.text =  [self.items objectAtIndex:indexPath.row];
    
    return cell;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"DID SELECT");
}
@end
