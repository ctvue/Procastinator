//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Max Lettenberger and Chee Vue on 5/18/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property NSMutableArray *tasks;
@property NSMutableArray *colors;
@property NSMutableArray *colorOptions;
@property NSInteger cursor;
@property NSIndexPath *_indexPath1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Populate array with sample tasks
    self.tasks = [[NSMutableArray alloc] init];
    [self.tasks addObject:@"Task 1"];
    [self.tasks addObject:@"Task 2"];
    [self.tasks addObject:@"Task 3"];
    [self.tasks addObject:@"Task 4"];
    [self.tasks addObject:@"Task 5"];
    [self.tasks addObject:@"Task 6"];
    [self.tasks addObject:@"Task 7"];
    [self.tasks addObject:@"Task 8"];
    [self.tasks addObject:@"Task 9"];
    [self.tasks addObject:@"Task 10"];

//    for(int i=0;i<15;i++){
//        [self.tasks addObject:[NSString stringWithFormat:@"Task %d", i]];
//    }

    self.colors = [[NSMutableArray alloc] init];
    [self.colors addObject:[UIColor blackColor]];
    [self.colors addObject:[UIColor blackColor]];
    [self.colors addObject:[UIColor blackColor]];
    [self.colors addObject:[UIColor blackColor]];
    [self.colors addObject:[UIColor blackColor]];
    [self.colors addObject:[UIColor blackColor]];
    [self.colors addObject:[UIColor blackColor]];
    [self.colors addObject:[UIColor blackColor]];
    [self.colors addObject:[UIColor blackColor]];
    [self.colors addObject:[UIColor blackColor]];

    self.colorOptions = [NSMutableArray arrayWithObjects:[UIColor redColor], [UIColor yellowColor], [UIColor greenColor], nil];

    self.table.allowsMultipleSelectionDuringEditing = NO;

    //Setup Swipe gesture recognizer to handler (IBAction)swipe:
    UISwipeGestureRecognizer *swipePriority = [[UISwipeGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(swipe:)];
    swipePriority.direction = UISwipeGestureRecognizerDirectionRight;
    [self.table addGestureRecognizer:swipePriority];

//    self.table.delegate = self;
//    self.table.dataSource = self;
}

#pragma mark - Table View methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tasks.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.tasks objectAtIndex:indexPath.row]];
    cell.textLabel.textColor = [self.colors objectAtIndex:indexPath.row];
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
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.title = @"Delete?";
        alert.message = @"Are you sure you want to delete?";
        [alert addButtonWithTitle:@"No"];
        [alert addButtonWithTitle:@"Yes"];
        alert.delegate = self;

        [alert show];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.editButton.titleLabel isEqual:@"Done"]){
        [self.tasks removeObjectAtIndex:indexPath.row];
        [self.table reloadData];
    } else {
        cell.textLabel.textColor = [UIColor greenColor];
        [self.colors replaceObjectAtIndex:indexPath.row withObject:[UIColor greenColor]];
        //[self.colors setObject:[UIColor greenColor] atIndexedSubscript:indexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *item = [self.tasks objectAtIndex:sourceIndexPath.row];
    UIColor *colorChange = [self.colors objectAtIndex:sourceIndexPath.row];
    [self.tasks removeObject:item];
    [self.tasks insertObject:item atIndex:destinationIndexPath.row];
    [self.colors removeObject:colorChange];
    [self.colors insertObject:colorChange atIndex:destinationIndexPath.row];
    [self.table reloadData];
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Button/Swipe methods

- (IBAction)onAddButtonPressed:(UIButton *)sender
{
    NSString *toDoItem = self.textField.text;
    if ([toDoItem length] == 0) {
        return;
    }

    [self.tasks addObject:toDoItem];
    [self.table reloadData];
    self.textField.text = nil; //    self.textField.text = @"";
    [self.textField resignFirstResponder];
    [self.colors addObject:[UIColor blackColor]];
    [self.view endEditing:YES];
}

- (IBAction)onEditButtonPressed:(UIButton *)sender
{


//    if (self.table.editing) {
//        sender.titleLabel.text = @"Edit";
//        self.table.editing = false;
//    } else {
//        sender.titleLabel.text = @"Done";
//        self.table.editing = true;
//    }

    if([self.table isEditing])
    {
        [self.table setEditing:NO animated:NO];
        [self.table reloadData];
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
    }
    else
    {
        [self.table setEditing:YES animated:YES];
        [sender setTitle:@"Done" forState:UIControlStateNormal];
    }

}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender
{
//    //Get gesture location
//    CGPoint gestureLocation = [sender locationInView:self.table];
//    //Getting IndexPath for that location in tableview
//    NSIndexPath *swipedIndexPath = [self.table indexPathForRowAtPoint:gestureLocation];
//    UITableViewCell *swipedCell  = [self.table cellForRowAtIndexPath:swipedIndexPath];
//    if (UISwipeGestureRecognizerDirectionRight)
//    {
//        self.cursor -= 1;
//        if (self.cursor < 0) {
//            self.cursor = self.colorOptions.count - 1;
//        }
//        UIColor *color = self.colorOptions[self.cursor];
//        swipedCell.textLabel.textColor = color;
//        [self.table reloadData]; //might not need this
//    }


    //Nadir's code
    CGPoint location = [sender locationInView:self.table];
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:location];

    if (indexPath) {
        UITableViewCell *cell = [self.table cellForRowAtIndexPath:indexPath];

        if (cell.textLabel.textColor == [UIColor blackColor]) {
            cell.textLabel.textColor = [UIColor redColor];
            [self.colors setObject:[UIColor redColor] atIndexedSubscript:indexPath.row];
        } else if (cell.textLabel.textColor == [UIColor redColor]){
            cell.textLabel.textColor = [UIColor yellowColor];
            [self.colors setObject:[UIColor yellowColor] atIndexedSubscript:indexPath.row];
        } else if (cell.textLabel.textColor == [UIColor yellowColor]){
            cell.textLabel.textColor = [UIColor greenColor];
            [self.colors setObject:[UIColor greenColor] atIndexedSubscript:indexPath.row];
        } else {
            cell.textLabel.textColor = [UIColor blackColor];
            [self.colors setObject:[UIColor blackColor] atIndexedSubscript:indexPath.row];
        }
    }
}

#pragma mark - UIAlertView methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.tasks removeObjectAtIndex:[self._indexPath1 row]];
        [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:self._indexPath1] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
