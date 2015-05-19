//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Max Lettenberger on 5/18/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property NSMutableArray *tasks;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property NSInteger cursor;
@property NSArray *colors;
@property NSIndexPath *_indexPath1;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tasks = [[NSMutableArray alloc] init];

    self.table.delegate = self;
    self.table.dataSource = self;

    self.colors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor yellowColor], [UIColor greenColor], nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tasks.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];

//    if (cell == nil) {
//        <#statements#>
//    }

    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.tasks[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        self._indexPath1 = indexPath;
        //NSObject *object = [self.tasks objectAtIndex:indexPath.row];
//        [self.tasks removeObjectAtIndex:indexPath.row];
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }

    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.title = @"Delete?";
    alert.message = @"Are you sure you want to delete?";
    [alert addButtonWithTitle:@"No"];
    [alert addButtonWithTitle:@"Yes"];
    alert.delegate = self;
    [alert show];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor greenColor];
}

- (IBAction)onAddButtonPressed:(UIButton *)sender
{
    [self.tasks addObject:self.textField.text];

    self.textField.text = @"";
    [self.textField resignFirstResponder];

    NSLog(@"%@", self.tasks[0]);

    [self.table reloadData];

}

- (IBAction)onEditButtonPressed:(UIButton *)sender
{
    [sender setTitle:@"Done" forState:UIControlStateNormal];

    [self.table setEditing:YES animated:YES];
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender
{
    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:@"CellID"];
    UISwipeGestureRecognizerDirection direction = [sender direction];
    if (direction == UISwipeGestureRecognizerDirectionRight)
    {
        NSLog(@"asdf");
        self.cursor -= 1;

        if (self.cursor < 0) {
            self.cursor = self.colors.count - 1;

           // NSLog([NSString stringWithFormat:@"%ld", (long)self.cursor]);
        }

        UIColor *color = self.colors[self.cursor];
        cell.textLabel.textColor = color;

    }

}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *item = [self.tasks objectAtIndex:sourceIndexPath.row];
    [self.tasks removeObject:item];
    [self.tasks insertObject:item atIndex:destinationIndexPath.row];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.tasks removeObjectAtIndex:[self._indexPath1 row]];
        [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:self._indexPath1] withRowAnimation:UITableViewRowAnimationFade];

        //[__indexPath1 retain];

        for (NSString *task in self.tasks) {
            NSLog(@"%@", task);
        }
    }
}

@end
